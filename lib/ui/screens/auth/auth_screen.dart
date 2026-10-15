import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/soul_connection_art.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isRegister = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitEmailAuth(AppStateProvider provider, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await provider.authenticateWithEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        isRegister: _isRegister,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitAppleAuth(AppStateProvider provider) async {
    setState(() => _isLoading = true);
    try {
      await provider.signInWithApple();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final loc = AppLocalizations.of(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: App Name & Language Picker Chip
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc?.translate('appName') ?? 'GHARAR',
                          style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            fontSize: 22,
                            color: isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                          ),
                        ),
                        Text(
                          provider.currentLanguage.tagline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                            fontSize: 10,
                            letterSpacing: 0.5,
                            color: isDark
                                ? AppColors.lavenderAccent
                                : AppColors.burgundyRose,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Multilingual Language Switcher Chip (8 Languages & RTL)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showLanguagePickerSheet(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardElevated
                            : AppColors.blushPinkLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.blushPinkDeep.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(provider.currentLanguage.flag,
                              style: const TextStyle(fontSize: 15)),
                          const SizedBox(width: 5),
                          Text(
                            provider.currentLanguage.nativeName,
                            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Hero Soul Connection Artwork (Two Souls with Glowing Heart Bridge)
              const Center(
                child: SoulConnectionArt(
                  width: 260,
                  height: 200,
                  animateGlow: true,
                ),
              ),

              const SizedBox(height: 18),

              // Title & Subtitle
              Text(
                loc?.translate('authTitle') ?? 'Welcome to Your Sanctuary',
                textAlign: TextAlign.center,
                style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  loc?.translate('authSubtitle') ??
                      'Sign in with your Apple ID or email to deepen your connection.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextMuted,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign in with Apple ID Button (Apple HIG Compliance)
              _buildAppleSignInButton(context, provider, loc, isDark),

              const SizedBox(height: 18),

              // Or continue with email Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      loc?.translate('orDivider') ?? 'or continue with email',
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Mode Switcher Tabs (Sign In vs New Account)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : AppColors.blushPinkLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isRegister = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isRegister
                                ? (isDark ? AppColors.darkCard : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !_isRegister
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              loc?.translate('signInTab') ?? 'Sign In',
                              style: TextStyle(
                                fontWeight:
                                    !_isRegister ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 13,
                                color: !_isRegister
                                    ? (isDark
                                        ? AppColors.blushPinkDeep
                                        : AppColors.deepBurgundy)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextMuted),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isRegister = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isRegister
                                ? (isDark ? AppColors.darkCard : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isRegister
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              loc?.translate('registerTab') ?? 'New Account',
                              style: TextStyle(
                                fontWeight:
                                    _isRegister ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 13,
                                color: _isRegister
                                    ? (isDark
                                        ? AppColors.blushPinkDeep
                                        : AppColors.deepBurgundy)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextMuted),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Form Fields Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field (Shown when Registering)
                      if (_isRegister) ...[
                        Text(
                          loc?.translate('enterYourName') ?? 'Your Name',
                          style: AppTextStyles.labelLarge(isDark: isDark).copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_rounded, size: 20),
                            hintText: loc?.translate('enterYourName') ?? 'Your Name',
                          ),
                          validator: (val) {
                            if (_isRegister && (val == null || val.trim().isEmpty)) {
                              return loc?.translate('nameRequired') ?? 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email Field
                      Text(
                        loc?.translate('emailAddress') ?? 'Email Address',
                        style: AppTextStyles.labelLarge(isDark: isDark).copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_rounded, size: 20),
                          hintText: loc?.translate('emailHint') ?? 'name@example.com',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return loc?.translate('emailRequired') ?? 'Please enter your email address';
                          }
                          if (!val.contains('@') || !val.contains('.')) {
                            return loc?.translate('invalidEmail') ?? 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      Text(
                        loc?.translate('passwordHint') ?? 'Password',
                        style: AppTextStyles.labelLarge(isDark: isDark).copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.length < 6) {
                            return loc?.translate('passwordRequired') ??
                                'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 22),

                      // Submit Button
                      GradientButton(
                        text: _isLoading
                            ? '...'
                            : (loc?.translate('authContinue') ?? 'Enter Sanctuary ➔'),
                        onPressed: _isLoading ? null : () => _submitEmailAuth(provider, context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Privacy & Encryption Assurance

              // Privacy & Encryption Assurance
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_rounded, size: 14, color: AppColors.champagneGold),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Private & End-to-End Encrypted Couple Space',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton(
    BuildContext context,
    AppStateProvider provider,
    AppLocalizations? loc,
    bool isDark,
  ) {
    // Official Apple Sign In Button styling per Apple HIG:
    // Light mode: Solid Black background, White text & logo.
    // Dark mode: Solid White background, Black text & logo.
    final bgColor = isDark ? Colors.white : Colors.black;
    final fgColor = isDark ? Colors.black : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _isLoading ? null : () => _submitAppleAuth(provider),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.apple, color: fgColor, size: 24),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  loc?.translate('signInWithApple') ?? 'Sign in with Apple',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePickerSheet(
      BuildContext context, AppStateProvider provider) {
    final isDark = provider.isDarkMode;
    final currentLang = provider.currentLanguage;
    final isTr = provider.isTurkish;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.78,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardElevated : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text('🌍', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTr ? 'Uygulama Dili Seçin' : 'Choose App Language',
                            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isTr
                                ? '8 dil desteği ve sağdan sola (RTL) tam uyum'
                                : '8 languages supported with full RTL & LTR script harmony',
                            style: AppTextStyles.bodySmall(isDark: isDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: AppLanguage.supportedLanguages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, index) {
                    final lang = AppLanguage.supportedLanguages[index];
                    final isSelected = lang.code == currentLang.code;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        provider.setLanguageCode(lang.code);
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.blushPinkDeep
                                      .withValues(alpha: 0.22)
                                  : AppColors.blushPinkLight)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy)
                                : (isDark
                                    ? AppColors.darkBorder
                                        .withValues(alpha: 0.5)
                                    : AppColors.lightBorder),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(lang.flag,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lang.nativeName,
                                        style: AppTextStyles.titleMedium(
                                                isDark: isDark)
                                            .copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${lang.name})',
                                        style: AppTextStyles.bodySmall(
                                                isDark: isDark)
                                            .copyWith(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextMuted,
                                        ),
                                      ),
                                      if (lang.isRtl) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.champagneGold
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'RTL',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.champagneGold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang.tagline,
                                    style: AppTextStyles.bodySmall(
                                            isDark: isDark)
                                        .copyWith(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: isDark
                                          ? AppColors.lavenderAccent
                                          : AppColors.burgundyRose,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
