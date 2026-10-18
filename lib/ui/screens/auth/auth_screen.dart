import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';

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

  void _submitEmailAuth(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<AppStateProvider>().authenticateWithEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        isRegister: _isRegister,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitAppleAuth(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await context.read<AppStateProvider>().signInWithApple();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitGoogleAuth(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await context.read<AppStateProvider>().signInWithGoogle();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitGuestAuth(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await context.read<AppStateProvider>().continueAsGuest();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog(BuildContext context, bool isDark, bool isTr) {
    final emailText = _emailController.text.trim();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              isTr ? 'Şifre Sıfırlama' : 'Forgot Password',
              style: AppTextStyles.titleMedium(
                isDark: isDark,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
            content: Text(
              emailText.isNotEmpty
                  ? (isTr
                      ? '$emailText adresine şifre sıfırlama bağlantısı gönderildi.'
                      : 'Password reset instructions have been sent to $emailText.')
                  : (isTr
                      ? 'Lütfen e-posta adresinizi girin.'
                      : 'Please enter your email in the field first.'),
              style: AppTextStyles.bodyMedium(isDark: isDark),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  isTr ? 'Tamam' : 'OK',
                  style: TextStyle(
                    color:
                        isDark
                            ? AppColors.terracottaLight
                            : AppColors.terracotta,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final currentLanguage = context.select<AppStateProvider, AppLanguage>(
      (p) => p.currentLanguage,
    );
    final loc = AppLocalizations.of(context);
    final isTr = currentLanguage.code == 'tr';

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Background with subtle organic concentric curved lines matching user design
          Positioned.fill(
            child: CustomPaint(
              painter: ConcentricSoulBackgroundPainter(isDark: isDark),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top Bar: Brand text & Language Switcher
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                loc?.translate('appName') ?? 'GHARAR',
                                style: AppTextStyles.displaySmall(
                                  isDark: isDark,
                                ).copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  fontSize: 18,
                                  color:
                                      isDark
                                          ? AppColors.blushPinkDeep
                                          : AppColors.deepBurgundy,
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap:
                                    () => _showLanguagePickerSheet(
                                      context,
                                      isDark,
                                      currentLanguage,
                                    ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? AppColors.darkCardElevated
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          isDark
                                              ? AppColors.darkBorder
                                              : AppColors.parchmentBorder,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        currentLanguage.flag,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        currentLanguage.nativeName,
                                        style: AppTextStyles.bodySmall(
                                          isDark: isDark,
                                        ).copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        Icons.arrow_drop_down_rounded,
                                        size: 16,
                                        color:
                                            isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Large Centered Title (Login / Create Account)
                          Text(
                            _isRegister
                                ? (loc?.translate('registerTitle') ??
                                    (isTr ? 'Hesap Oluştur' : 'Create Account'))
                                : (loc?.translate('loginTitle') ??
                                    (isTr ? 'Giriş Yap' : 'Login')),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.displaySmall(
                              isDark: isDark,
                            ).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                              letterSpacing: -0.5,
                              color:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.inkCharcoal,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Segmented Mode Selector Pill (Sign In / New Account)
                          AuthModeSegmentedPill(
                            isRegister: _isRegister,
                            isDark: isDark,
                            signInLabel:
                                loc?.translate('signInTab') ??
                                (isTr ? 'Giriş Yap' : 'Sign In'),
                            registerLabel:
                                loc?.translate('registerTab') ??
                                (isTr ? 'Yeni Hesap' : 'New Account'),
                            onSelectSignIn:
                                () => setState(() => _isRegister = false),
                            onSelectRegister:
                                () => setState(() => _isRegister = true),
                          ),

                          const SizedBox(height: 20),

                          // Form Fields with Pill Design
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Name field (when registering)
                                if (_isRegister) ...[
                                  AuthPillTextField(
                                    controller: _nameController,
                                    hintText:
                                        loc?.translate('enterYourName') ??
                                        (isTr ? 'Adınız' : 'Your Name'),
                                    prefixIcon: Icons.person_outline_rounded,
                                    isDark: isDark,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (val) {
                                      if (_isRegister &&
                                          (val == null || val.trim().isEmpty)) {
                                        return loc?.translate('nameRequired') ??
                                            'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                ],

                                // Email field
                                AuthPillTextField(
                                  controller: _emailController,
                                  hintText:
                                      loc?.translate('emailHint') ??
                                      (isTr ? 'E-posta' : 'Email'),
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  isDark: isDark,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return loc?.translate('emailRequired') ??
                                          'Please enter your email address';
                                    }
                                    if (!val.contains('@') ||
                                        !val.contains('.')) {
                                      return loc?.translate('invalidEmail') ??
                                          'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                // Password field
                                AuthPillTextField(
                                  controller: _passwordController,
                                  hintText:
                                      loc?.translate('passwordHint') ??
                                      (isTr ? 'Şifre' : 'Password'),
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  isDark: isDark,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 19,
                                      color:
                                          isDark
                                              ? AppColors.darkTextMuted
                                              : AppColors.lightTextMuted,
                                    ),
                                    onPressed:
                                        () => setState(
                                          () =>
                                              _obscurePassword =
                                                  !_obscurePassword,
                                        ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.length < 6) {
                                      return loc?.translate(
                                            'passwordRequired',
                                          ) ??
                                          'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Forgot Password link
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed:
                                  () => _showForgotPasswordDialog(
                                    context,
                                    isDark,
                                    isTr,
                                  ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: Text(
                                loc?.translate('forgotPassword') ??
                                    (isTr
                                        ? 'Şifrenizi mi unuttunuz?'
                                        : 'Forgot Password?'),
                                style: AppTextStyles.bodySmall(
                                  isDark: isDark,
                                ).copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Main Primary Button (Solid Dark Rounded Pill)
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isDark
                                        ? AppColors.earthSlateLight
                                        : AppColors.earthSlateDeep,
                                foregroundColor:
                                    isDark
                                        ? AppColors.earthSlateDeep
                                        : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () => _submitEmailAuth(context),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        _isRegister
                                            ? (loc?.translate('authContinue') ??
                                                (isTr
                                                    ? 'Devam Et'
                                                    : 'Continue'))
                                            : (loc?.translate('loginTitle') ??
                                                (isTr ? 'Giriş Yap' : 'Login')),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                          color:
                                              isDark
                                                  ? AppColors.earthSlateDeep
                                                  : Colors.white,
                                        ),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // or Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color:
                                      isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: Text(
                                  loc?.translate('or') ??
                                      (isTr ? 'veya' : 'or'),
                                  style: AppTextStyles.bodySmall(
                                    isDark: isDark,
                                  ).copyWith(
                                    fontSize: 12,
                                    color:
                                        isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color:
                                      isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Social Pill 1: Continue with Google
                          SocialPillButton(
                            label:
                                loc?.translate('continueWithGoogle') ??
                                (isTr
                                    ? 'Google ile Devam Et'
                                    : 'Continue with Google'),
                            icon: const GoogleGIcon(size: 19),
                            backgroundColor:
                                isDark ? AppColors.darkCard : Colors.white,
                            textColor:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.inkCharcoal,
                            borderColor:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                            isDark: isDark,
                            onPressed:
                                _isLoading
                                    ? null
                                    : () => _submitGoogleAuth(context),
                          ),

                          const SizedBox(height: 12),

                          // Social Pill 2: Continue with Apple (Featured Pill)
                          AppleSignInButton(
                            isDark: isDark,
                            isLoading: _isLoading,
                            label:
                                loc?.translate('signInWithApple') ??
                                (isTr
                                    ? 'Apple ile Giriş Yap'
                                    : 'Sign in with Apple'),
                            onPressed:
                                _isLoading
                                    ? null
                                    : () => _submitAppleAuth(context),
                          ),

                          const SizedBox(height: 12),

                          // Social Pill 3: Continue As Guest
                          SocialPillButton(
                            label:
                                loc?.translate('continueAsGuest') ??
                                (isTr
                                    ? 'Misafir Olarak Devam Et'
                                    : 'Continue As Guest'),
                            icon: Icon(
                              Icons.person_outline_rounded,
                              size: 20,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.inkCharcoal,
                            ),
                            backgroundColor:
                                isDark
                                    ? AppColors.darkCardElevated
                                    : const Color(0xFFF1ECE4),
                            textColor:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.inkCharcoal,
                            borderColor:
                                isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFE4DDD1),
                            isDark: isDark,
                            onPressed:
                                _isLoading
                                    ? null
                                    : () => _submitGuestAuth(context),
                          ),

                          const SizedBox(height: 24),

                          // Footer Toggle: "Need an account? Sign up" / "Already have an account? Log in"
                          Center(
                            child: GestureDetector(
                              onTap:
                                  () => setState(
                                    () => _isRegister = !_isRegister,
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTextStyles.bodyMedium(
                                      isDark: isDark,
                                    ).copyWith(
                                      fontSize: 13,
                                      color:
                                          isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.inkMuted,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            _isRegister
                                                ? (loc?.translate(
                                                      'alreadyHaveAccount',
                                                    ) ??
                                                    (isTr
                                                        ? 'Zaten bir hesabınız var mı? '
                                                        : 'Already have an account? '))
                                                : (loc?.translate(
                                                      'needAccount',
                                                    ) ??
                                                    (isTr
                                                        ? 'Hesabınız yok mu? '
                                                        : 'Need an account? ')),
                                      ),
                                      TextSpan(
                                        text:
                                            _isRegister
                                                ? (loc?.translate(
                                                      'signInTab',
                                                    ) ??
                                                    (isTr
                                                        ? 'Giriş Yap'
                                                        : 'Log in'))
                                                : (loc?.translate(
                                                      'registerTab',
                                                    ) ??
                                                    (isTr
                                                        ? 'Yeni Hesap'
                                                        : 'Sign up')),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color:
                                              isDark
                                                  ? AppColors.terracottaLight
                                                  : AppColors.terracotta,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePickerSheet(
    BuildContext context,
    bool isDark,
    AppLanguage currentLang,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) =>
              AuthLanguagePickerSheet(isDark: isDark, currentLang: currentLang),
    );
  }
}

/// Custom Background Painter drawing graceful concentric resonance waves matching the design
class ConcentricSoulBackgroundPainter extends CustomPainter {
  final bool isDark;

  const ConcentricSoulBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor =
        isDark
            ? const Color(0xFF332F37).withValues(alpha: 0.35)
            : const Color(0xFFE4D8C5).withValues(alpha: 0.55);

    final paint =
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..isAntiAlias = true;

    // Center point located slightly above left/center as in reference mockup
    final center = Offset(size.width * 0.45, size.height * 0.35);
    final maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height) * 0.9;

    // Draw concentric organic resonance rings
    for (double r = 80; r < maxRadius; r += 55) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConcentricSoulBackgroundPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// Rounded Pill Text Field matching the clean reference image
class AuthPillTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool isDark;

  const AuthPillTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color:
                isDark ? AppColors.terracottaLight : AppColors.earthSlateDeep,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
      ),
    );
  }
}

/// Generic Social Pill Button matching the reference image
class SocialPillButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final bool isDark;
  final VoidCallback? onPressed;

  const SocialPillButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Apple Sign In Button styled as the featured vibrant pill shown in the mockup
class AppleSignInButton extends StatelessWidget {
  final bool isDark;
  final bool isLoading;
  final String label;
  final VoidCallback? onPressed;

  const AppleSignInButton({
    super.key,
    required this.isDark,
    required this.isLoading,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // In reference image: Vibrant featured pill (lime/spring green pill with dark text)
    // In dark mode: High contrast clean pill
    final Color bgColor =
        isDark ? const Color(0xFF98E266) : const Color(0xFF98E266);
    const Color fgColor = Color(0xFF1D2218);

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple, color: fgColor, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: fgColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Crisp, pixel-perfect 4-color Google "G" Logo drawn natively on Canvas
class GoogleGIcon extends StatelessWidget {
  final double size;

  const GoogleGIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _GoogleGLogoPainter());
  }
}

class _GoogleGLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final paintBlue =
        Paint()
          ..color = const Color(0xFF4285F4)
          ..style = PaintingStyle.fill;
    final paintRed =
        Paint()
          ..color = const Color(0xFFEA4335)
          ..style = PaintingStyle.fill;
    final paintYellow =
        Paint()
          ..color = const Color(0xFFFBBC05)
          ..style = PaintingStyle.fill;
    final paintGreen =
        Paint()
          ..color = const Color(0xFF34A853)
          ..style = PaintingStyle.fill;

    // Draw stylized colored 4-quadrant segments of the Google G
    final pathBlue =
        Path()
          ..moveTo(center.dx, center.dy - radius * 0.2)
          ..lineTo(w, center.dy - radius * 0.2)
          ..lineTo(w, center.dy + radius * 0.2)
          ..lineTo(center.dx + radius * 0.3, center.dy + radius * 0.2)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            0,
            math.pi / 4,
            false,
          )
          ..lineTo(center.dx, center.dy)
          ..close();
    canvas.drawPath(pathBlue, paintBlue);

    // Green segment (bottom)
    final pathGreen =
        Path()
          ..moveTo(center.dx, center.dy)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            math.pi / 4,
            math.pi * 0.5,
            false,
          )
          ..close();
    canvas.drawPath(pathGreen, paintGreen);

    // Yellow segment (bottom left)
    final pathYellow =
        Path()
          ..moveTo(center.dx, center.dy)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            math.pi * 0.75,
            math.pi * 0.45,
            false,
          )
          ..close();
    canvas.drawPath(pathYellow, paintYellow);

    // Red segment (top)
    final pathRed =
        Path()
          ..moveTo(center.dx, center.dy)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            math.pi * 1.2,
            math.pi * 0.75,
            false,
          )
          ..close();
    canvas.drawPath(pathRed, paintRed);

    // Cut out inner circle to form the 'G' cutout
    final innerClearPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.55, innerClearPaint);

    // Draw the horizontal G bridge in Blue
    final bridgePath =
        Path()
          ..moveTo(center.dx, center.dy - radius * 0.2)
          ..lineTo(center.dx + radius * 0.95, center.dy - radius * 0.2)
          ..lineTo(center.dx + radius * 0.95, center.dy + radius * 0.2)
          ..lineTo(center.dx, center.dy + radius * 0.2)
          ..close();
    canvas.drawPath(bridgePath, paintBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Language Selector Modal Sheet
class AuthLanguagePickerSheet extends StatelessWidget {
  final bool isDark;
  final AppLanguage currentLang;

  const AuthLanguagePickerSheet({
    super.key,
    required this.isDark,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context) {
    final isTr = currentLang.code == 'tr';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
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
                        style: AppTextStyles.titleMedium(
                          isDark: isDark,
                        ).copyWith(fontWeight: FontWeight.w800, fontSize: 18),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: AppLanguage.supportedLanguages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, index) {
                final lang = AppLanguage.supportedLanguages[index];
                final isSelected = lang.code == currentLang.code;

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    context.read<AppStateProvider>().setLanguageCode(lang.code);
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? (isDark
                                  ? AppColors.terracottaLight.withValues(
                                    alpha: 0.22,
                                  )
                                  : AppColors.terracottaSubtle)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected
                                ? (isDark
                                    ? AppColors.terracottaLight
                                    : AppColors.terracotta)
                                : (isDark
                                    ? AppColors.darkBorder.withValues(
                                      alpha: 0.5,
                                    )
                                    : AppColors.lightBorder),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 28)),
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
                                      isDark: isDark,
                                    ).copyWith(
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${lang.name})',
                                    style: AppTextStyles.bodySmall(
                                      isDark: isDark,
                                    ).copyWith(
                                      fontSize: 12,
                                      color:
                                          isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextMuted,
                                    ),
                                  ),
                                  if (lang.isRtl) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.heartGold.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'RTL',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.heartGold,
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
                                  isDark: isDark,
                                ).copyWith(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color:
                                      isDark
                                          ? AppColors.terracottaLight
                                          : AppColors.terracotta,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color:
                                isDark
                                    ? AppColors.terracottaLight
                                    : AppColors.terracotta,
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
  }
}

/// Segmented pill to toggle between Sign In and Register modes
class AuthModeSegmentedPill extends StatelessWidget {
  final bool isRegister;
  final bool isDark;
  final String signInLabel;
  final String registerLabel;
  final VoidCallback onSelectSignIn;
  final VoidCallback onSelectRegister;

  const AuthModeSegmentedPill({
    super.key,
    required this.isRegister,
    required this.isDark,
    required this.signInLabel,
    required this.registerLabel,
    required this.onSelectSignIn,
    required this.onSelectRegister,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.darkCard : const Color(0xFFF0EBE1);
    final activeBg = isDark ? AppColors.darkCardElevated : Colors.white;
    final activeTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal;
    final inactiveTextColor =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Sign In Pill Tab
          Expanded(
            child: GestureDetector(
              onTap: onSelectSignIn,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isRegister ? activeBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow:
                      !isRegister
                          ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  signInLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: !isRegister ? FontWeight.w700 : FontWeight.w500,
                    color: !isRegister ? activeTextColor : inactiveTextColor,
                  ),
                ),
              ),
            ),
          ),
          // Register Pill Tab
          Expanded(
            child: GestureDetector(
              onTap: onSelectRegister,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isRegister ? activeBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow:
                      isRegister
                          ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  registerLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isRegister ? FontWeight.w700 : FontWeight.w500,
                    color: isRegister ? activeTextColor : inactiveTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
