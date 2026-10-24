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
  deleteDoc,
  doc,
  getDoc,
  setDoc,
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

  test('membership stays between one and two people', async () => {
    await seedCouple(['kerem']);
    await assertFails(
      setDoc(doc(as('kerem'), 'couples/c1'), { memberUids: [] }, { merge: true }),
    );
    await assertSucceeds(
      setDoc(
        doc(as('kerem'), 'couples/c1'),
        { memberUids: arrayUnion('elif') },
        { merge: true },
      ),
    );
    await assertFails(
      setDoc(
        doc(as('kerem'), 'couples/c1'),
        { memberUids: arrayUnion('mallory') },
        { merge: true },
      ),
    );
  });

  test('couples cannot be deleted', async () => {
    await seedCouple(['kerem']);
    await assertFails(deleteDoc(doc(as('kerem'), 'couples/c1')));
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

test('everything outside users and couples is denied', async () => {
  await assertFails(setDoc(doc(as('kerem'), 'misc/x'), { a: 1 }));
});
