# 💖 GHARAR (قَرار)
> **"Deepen your bond, every single day."** • *"Her gün birbirinize bir adım daha yakın."*

[![GHARAR Flutter CI](https://github.com/MitraZahiri/GHARAR/actions/workflows/ci.yml/badge.svg)](https://github.com/MitraZahiri/GHARAR/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.29.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.0-0175C2?logo=dart)](https://dart.dev)
[![Release](https://img.shields.io/badge/Release-v1.0.0-8E2A40)](https://github.com/MitraZahiri/GHARAR/releases)
[![License](https://img.shields.io/badge/License-MIT-E2B774)](#)

---

## 🕊️ About GHARAR
**GHARAR** is a modern, emotionally engaging, mobile-first relationship sanctuary built exclusively in Flutter to help couples strengthen their love, communicate with tenderness, discover shared passions, celebrate healthy differences, and preserve lifelong memories together.

Designed as a harmonious fusion of:
- 📖 **A Private Couple Journal**
- 🕊️ **An Empathetic Relationship Coach (Noor AI)**
- 🎯 **A "How Well Do You Know Each Other?" Compatibility Game**
- 🕯️ **A Romantic Activity & Date Planner**
- 💌 **A Daily Connection & Mutual-Reveal Experience**

---

## 🎨 Visual Identity & Aesthetic
GHARAR utilizes a warm, romantic, sophisticated palette:
- **Soft Blush Pink** (`#F9D8DE`, `#FFF0F3`)
- **Warm Cream & Ivory** (`#FFF9F5`, `#FAF3EE`)
- **Muted Lavender** (`#E8E0F0`, `#8E79B2`)
- **Deep Burgundy & Wine** (`#6B1D2F`, `#4A0E1B`)
- **Subtle Peach & Coral Gold** (`#FFD8CC`, `#E07A5F`)
- **Champagne Gold Accents** (`#E2B774`, `#F4D06F`)
- **Velvet Burgundy Dark Mode** for cozy, late-night intimacy

Typography blends **Playfair Display** for poetic, elegant headlines with **Plus Jakarta Sans** for crisp, modern mobile legibility.

---

## ✨ Key Features

### 1. 💌 Daily Questions with Mutual-Reveal Privacy
- Over **100+ thoughtfully crafted questions** across **12 categories**:
  - *Love & Affection*, *Emotional Intimacy*, *Childhood & Roots*, *Cherished Memories*, *Communication*, *Future Dreams*, *Core Values*, *Playful Fun*, *Romance & Passion*, *Personal Growth*, *Lifestyle & Rhythm*, and *Midnight Deep Dive*.
- **3 Intensity Levels**: 🌱 Light & Playful, 🌿 Heartfelt & Meaningful, 🌺 Deep Soul Exploration.
- **Strict Privacy**: Your partner cannot view your answer until both of you have submitted! Once both submit, a celebratory confetti reveal unlocks side-by-side answers, love reactions, and guided reflection prompts.
- **Skip Questions Without Guilt**: Draw another question anytime without penalties.

### 2. 🎯 "How Well Do You Know Each Other?" Game
- Playful prediction quizzes testing how well you know your partner's dream Sunday, comfort food cravings, travel bucket lists, and secret wishes.
- Interactive reveal animations that foster curiosity and gentle laughter rather than unhealthy competition.

### 3. ⚖️ Shared Interests & "Beautiful Differences"
- Real-time compatibility discovery across Travel, Music, Culinary Rituals, and Lifestyle.
- **"Discover Something New About Us"**: Intelligently reframes contrasting habits (e.g., spontaneous road trips vs. cozy home routines) as respectful, loving conversation starters and golden-balance date ideas.

### 4. 🕯️ Couple Experiences & Date Planner
- 50+ curated couple date ideas (At-Home, Outdoor, Romantic, Culinary, Low-Budget).
- Filter by **Budget** (Free, $, $$, $$$), **Setting** (Home, Indoor, Outdoor), **Vibe** (Romantic, Adventurous, Relaxing, Playful), and **Duration**.
- Save to Couple Bucket List and mark as completed.

### 5. 🎲 Romantic Surprise Generator
- Spontaneous romance generator: roll thoughtful gestures, secret love sticky notes, sensory taste tests, and massage rituals.

### 6. 🏆 Weekly Couple Challenges & Collectible Badges
- Small, achievable intimacy missions (e.g., "The 3 Unspoken Appreciations", "Digital Sunset Bubble", "Recreating First Date Spark").
- Unlock collectible badges (*Grateful Hearts*, *Sanctuary of Peace*, *Nostalgic Spark*) and connection streaks without guilt.

### 7. 🧭 "Where Are We Heading?" Future Alignment
- Explore future pillars: Living Sanctuaries, Travel Horizons, Financial Harmony, and Family Traditions.
- Compassionate side-by-side comparison highlighting shared aspirations.

### 8. 📖 Private Couple Journal & Memory Timeline
- Document unforgettable moments, candlelit balcony dinners, and first dates.
- Chronological Memory Timeline with celebratory milestone badges (*First Spark*, *Adventure Unlocked*, *365 Days of Us*).

### 9. ⏳ Special Dates & Anniversary Calendar
- Birthdays, anniversaries, and planned getaways with automatic countdown timers.

### 10. 🤖 Noor • AI Relationship Companion
- An empathetic, non-judgmental guide.
- Reframes raw feelings into constructive "I" statements, sparks date ideas, and de-escalates small disagreements without replacing professional therapy.

### 11. 🔄 Interactive Partner Switcher (Simulation Mode)
- Test and experience both partner perspectives (e.g. Mitra 🌸 & Deniz 🌿) with a single tap in the app bar! Allows full demonstration of the mutual reveal system without requiring two separate phones.

### 12. 🌍 Dual-Language Localization (English & Turkish)
- Instant live switching between **English 🇬🇧** and **Türkçe 🇹🇷**.

### 13. 👑 GHARAR Premium Tier
- Transparent, non-manipulative premium option with unlimited questions, expanded memory storage, and full Noor AI companion features.

---

## 🏗️ Architecture & Project Structure

```
lib/
├── core/
│   ├── localization/
│   │   └── app_localizations.dart       # English & Turkish dictionaries
│   ├── theme/
│   │   ├── app_colors.dart             # Romantic blush, burgundy, gold tokens
│   │   ├── app_text_styles.dart        # Playfair Display & Plus Jakarta Sans
│   │   └── app_theme.dart              # Light & Dark romantic ThemeData
│   └── utils/
│       └── responsive_wrapper.dart     # Mobile frame container for web/desktop
├── models/
│   ├── activity_model.dart             # Date ideas & multi-attribute filters
│   ├── ai_message_model.dart           # Noor conversation model
│   ├── challenge_model.dart            # Weekly couple challenges & badges
│   ├── couple_model.dart               # Couple space, streak, invite codes
│   ├── journal_entry_model.dart        # Couple journal entries & milestones
│   ├── question_model.dart             # Daily questions & mutual answers
│   ├── shared_interest_model.dart      # Sparks & respectful difference bridges
│   ├── special_date_model.dart         # Countdown calendar items
│   └── user_model.dart                 # Partner profiles & relationship stage
├── providers/
│   └── app_state_provider.dart         # Central reactive state & partner switcher
├── services/
│   ├── ai_companion_service.dart       # Noor empathetic coaching logic
│   ├── seed_data_service.dart          # 100+ questions, dates, challenges
│   └── storage_service.dart            # SharedPreferences local persistence
└── ui/
    ├── screens/
    │   ├── activities/                 # ActivitiesExplorer, SurpriseGenerator, Challenges
    │   ├── ai_companion/               # AICompanionScreen (Noor)
    │   ├── daily_questions/            # DailyQuestionScreen, AnswerReveal, QuestionVault
    │   ├── discover/                   # DiscoverHub, QuizGame, FutureAlignment
    │   ├── home/                       # HomeDashboardScreen
    │   ├── memories/                   # MemoriesHub, SpecialDates, AddMemoryModal
    │   ├── onboarding/                 # OnboardingScreen, PartnerInviteScreen
    │   ├── profile/                    # ProfileSettingsScreen, SubscriptionScreen
    │   └── main_navigation_shell.dart  # 5-tab persistent bottom navigation
    └── widgets/
        ├── confetti_overlay.dart       # Particle heart & petal burst animation
        ├── glass_card.dart             # Frosted romantic container
        ├── gradient_button.dart        # Velvety interactive gradient CTA
        ├── romantic_app_bar.dart       # Header with partner switcher & Noor button
        └── streak_badge.dart           # Animated connection streak flame
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.29.0`
- **Dart SDK**: `^3.7.0`

### Installation
```bash
# Clone the repository
git clone https://github.com/MitraZahiri/GHARAR.git
cd GHARAR

# Install dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run unit and widget tests
flutter test

# Run the app locally (Chrome, Android, iOS, Windows)
flutter run -d chrome
```

---

## 🧪 Testing & Verification
GHARAR includes full unit and widget test suites:
- `test/domain_test.dart`: Validates couple synchronization, privacy state machine, mutual reveal triggers, activity saving, challenge completion, and localization.
- `test/widget_test.dart`: Validates startup rendering, widget tree composition, and theme application.

Run tests anytime with:
```bash
flutter test
```

---

## 📜 License
Distributed under the MIT License. Built with love for couples everywhere. 💖
