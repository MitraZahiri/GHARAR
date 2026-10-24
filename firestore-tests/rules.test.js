// Security rules tests for ../firestore.rules. Run with `npm test`, which
// starts the Firestore emulator (needs Java 21+) around `node --test`.
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  arrayUnion,
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'gharar-rules-test',
    firestore: {
      rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
    },
  });
});

beforeEach(() => env.clearFirestore());
after(() => env.cleanup());

const as = (uid) => env.authenticatedContext(uid).firestore();
const signedOut = () => env.unauthenticatedContext().firestore();

/** Creates couples/c1 the way the app does, with the given members. */
async function seedCouple(memberUids) {
  await env.withSecurityRulesDisabled((ctx) =>
    setDoc(doc(ctx.firestore(), 'couples/c1'), { id: 'c1', memberUids }),
  );
}

describe('users/{uid}', () => {
  test('owner reads and writes their profile', async () => {
    await assertSucceeds(setDoc(doc(as('kerem'), 'users/kerem'), { name: 'K' }));
    await assertSucceeds(getDoc(doc(as('kerem'), 'users/kerem')));
  });

  test('nobody else can read or write it', async () => {
    await assertFails(getDoc(doc(as('mallory'), 'users/kerem')));
    await assertFails(setDoc(doc(as('mallory'), 'users/kerem'), { name: 'x' }));
    await assertFails(getDoc(doc(signedOut(), 'users/kerem')));
  });
});

describe('couples/{coupleId}', () => {
  test('a user creates a couple with only themselves as member', async () => {
    await assertSucceeds(
      setDoc(
        doc(as('kerem'), 'couples/c1'),
        { id: 'c1', memberUids: arrayUnion('kerem') },
        { merge: true },
      ),
    );
    await assertFails(
      setDoc(doc(as('mallory'), 'couples/c2'), {
        memberUids: ['mallory', 'kerem'],
      }),
    );
  });

  test('members read and update; repeated arrayUnion of self is fine', async () => {
    await seedCouple(['kerem']);
    await assertSucceeds(getDoc(doc(as('kerem'), 'couples/c1')));
    await assertSucceeds(
      setDoc(
        doc(as('kerem'), 'couples/c1'),
        { connectionStreak: 4, memberUids: arrayUnion('kerem') },
        { merge: true },
      ),
    );
  });

  test('non-members cannot read or join', async () => {
    await seedCouple(['kerem']);
    await assertFails(getDoc(doc(as('mallory'), 'couples/c1')));
    await assertFails(
      setDoc(
        doc(as('mallory'), 'couples/c1'),
        { memberUids: arrayUnion('mallory') },
        { merge: true },
      ),
    );
  });

  test('members cannot add anyone or leave themselves out', async () => {
    await seedCouple(['kerem']);
    await assertFails(
      setDoc(doc(as('kerem'), 'couples/c1'), { memberUids: [] }, { merge: true }),
    );
    await assertFails(
      setDoc(
        doc(as('kerem'), 'couples/c1'),
        { memberUids: arrayUnion('elif') },
        { merge: true },
      ),
    );
    await seedCouple(['kerem', 'elif']);
    await assertFails(
      updateDoc(doc(as('kerem'), 'couples/c1'), { memberUids: ['kerem', 'mallory'] }),
    );
  });

  test('either member can remove the other', async () => {
    await seedCouple(['kerem', 'elif']);
    await assertSucceeds(
      updateDoc(doc(as('elif'), 'couples/c1'), { memberUids: ['elif'], partner2: null }),
    );
    // Kerem is out now.
    await assertFails(getDoc(doc(as('kerem'), 'couples/c1')));
  });

  test('only a single-member couple can be deleted, by that member', async () => {
    await seedCouple(['kerem', 'elif']);
    await assertFails(deleteDoc(doc(as('kerem'), 'couples/c1')));
    await seedCouple(['kerem']);
    await assertFails(deleteDoc(doc(as('mallory'), 'couples/c1')));
    await assertSucceeds(deleteDoc(doc(as('kerem'), 'couples/c1')));
  });
});

describe('couples/{coupleId}/{collection}', () => {
  for (const collection of ['answers', 'loveNotes', 'journal', 'specialDates']) {
    test(`both members use ${collection}`, async () => {
      await seedCouple(['kerem', 'elif']);
      const path = `couples/c1/${collection}/x`;
      await assertSucceeds(setDoc(doc(as('kerem'), path), { a: 1 }));
      await assertSucceeds(getDoc(doc(as('elif'), path)));
      await assertSucceeds(deleteDoc(doc(as('elif'), path)));
    });
  }

  test('non-members are locked out', async () => {
    await seedCouple(['kerem', 'elif']);
    await assertFails(getDoc(doc(as('mallory'), 'couples/c1/journal/x')));
    await assertFails(setDoc(doc(as('mallory'), 'couples/c1/answers/y'), { a: 1 }));
    await assertFails(getDoc(doc(signedOut(), 'couples/c1/loveNotes/z')));
  });

  test('unknown subcollections and missing couples are denied', async () => {
    await seedCouple(['kerem']);
    await assertFails(setDoc(doc(as('kerem'), 'couples/c1/secrets/z'), { a: 1 }));
    await assertFails(setDoc(doc(as('kerem'), 'couples/nope/loveNotes/n'), { a: 1 }));
  });
});

describe('invites and joining', () => {
  /** couples/c1 owned by kerem with invite code CODE1, as the app sets up. */
  async function seedInvite() {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, 'couples/c1'), {
        id: 'c1',
        inviteCode: 'GHARAR-CODE01',
        memberUids: ['kerem'],
        isLinked: false,
      });
      await setDoc(doc(db, 'invites/GHARAR-CODE01'), {
        coupleId: 'c1',
        ownerUid: 'kerem',
      });
    });
  }

  const joinAs = (uid, overrides = {}) =>
    updateDoc(doc(as(uid), 'couples/c1'), {
      memberUids: arrayUnion(uid),
      joinCode: 'GHARAR-CODE01',
      partner2: { id: uid, name: 'Elif' },
      isLinked: true,
      ...overrides,
    });

  test('a member publishes and re-publishes their invite', async () => {
    await seedCouple(['kerem']);
    const invite = { coupleId: 'c1', ownerUid: 'kerem' };
    await assertSucceeds(setDoc(doc(as('kerem'), 'invites/GHARAR-NEW001'), invite));
    await assertSucceeds(setDoc(doc(as('kerem'), 'invites/GHARAR-NEW001'), invite));
  });

  test('nobody can publish an invite for a couple they are not in', async () => {
    await seedCouple(['kerem']);
    await assertFails(
      setDoc(doc(as('mallory'), 'invites/GHARAR-EVIL01'), {
        coupleId: 'c1',
        ownerUid: 'mallory',
      }),
    );
  });

  test('anyone signed in can look up one code, but not list them', async () => {
    await seedInvite();
    await assertSucceeds(getDoc(doc(as('elif'), 'invites/GHARAR-CODE01')));
    await assertFails(getDocs(collection(as('elif'), 'invites')));
    await assertFails(getDoc(doc(signedOut(), 'invites/GHARAR-CODE01')));
  });

  test('a partner joins with the right code, then removes the invite', async () => {
    await seedInvite();
    await assertSucceeds(joinAs('elif'));
    await assertSucceeds(getDoc(doc(as('elif'), 'couples/c1')));
    await assertSucceeds(deleteDoc(doc(as('elif'), 'invites/GHARAR-CODE01')));
  });

  test('joining needs the couple invite code', async () => {
    await seedInvite();
    await assertFails(joinAs('elif', { joinCode: 'GHARAR-WRONG1' }));
  });

  test('a joiner cannot change anything else', async () => {
    await seedInvite();
    await assertFails(joinAs('elif', { inviteCode: 'GHARAR-MINE01' }));
    await assertFails(joinAs('elif', { isPremium: true }));
  });

  test('a joiner can only add themselves', async () => {
    await seedInvite();
    await assertFails(joinAs('elif', { memberUids: arrayUnion('elif', 'mallory') }));
  });

  test('a full couple refuses a third person', async () => {
    await seedInvite();
    await assertSucceeds(joinAs('elif'));
    await assertFails(joinAs('mallory'));
  });

  test('strangers cannot delete an invite', async () => {
    await seedInvite();
    await assertFails(deleteDoc(doc(as('mallory'), 'invites/GHARAR-CODE01')));
  });
});

test('everything outside users and couples is denied', async () => {
  await assertFails(setDoc(doc(as('kerem'), 'misc/x'), { a: 1 }));
});
