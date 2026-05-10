import 'dart:ui';
import 'package:bear_animation_auth_pages/Providers/auth_page_change_provider.dart';
import 'package:bear_animation_auth_pages/ui/widgets/auth/auth_mode_transition.dart';
import 'package:bear_animation_auth_pages/ui/widgets/auth/sign_in_widget.dart';
import 'package:bear_animation_auth_pages/ui/widgets/auth/sign_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final riveUrl = 'assets/login_bear.riv';
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? stateMachineController;
  Artboard? artboard;

  static const _cream = Color(0xFFFFF7ED);
  static const _sunrise = Color(0xFFFFE4C4);
  static const _skyTint = Color(0xFFE8F4FC);

  @override
  void initState() {
    super.initState();
    rootBundle.load(riveUrl).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController = StateMachineController.fromArtboard(
        art,
        'Login Machine',
      );
      if (stateMachineController != null) {
        art.addController(stateMachineController!);
        for (final element in stateMachineController!.inputs) {
          if (element.name == 'isChecking') {
            isChecking = element as SMIBool;
          } else if (element.name == 'isHandsUp') {
            isHandsUp = element as SMIBool;
          } else if (element.name == 'numLook') {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() {
        artboard = art;
      });
    });
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(String value) {
    lookNum?.change(value.length.toDouble());
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void _onEmailFocusChanged(bool hasFocus) {
    if (hasFocus) lookAround();
  }

  void _onPasswordFocusChanged(bool hasFocus) {
    if (hasFocus) {
      handsUpOnEyes();
    } else {
      lookAround();
    }
  }

  @override
  void dispose() {
    stateMachineController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLogin = context.watch<AuthPageChangeProvider>().isLoginPage;
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    final transitionMs = (size.shortestSide * 0.82).round();
    final transitionDuration = Duration(milliseconds: transitionMs);
    final topInset = MediaQuery.paddingOf(context).top;

    final backdropGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(_cream, scheme.primaryContainer, 0.22)!,
        Color.lerp(_sunrise, scheme.secondaryContainer, 0.12)!,
        Color.lerp(_skyTint, scheme.surface, 0.85)!,
      ],
      stops: const [0.0, 0.42, 1.0],
    );

    final heroGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(scheme.primaryContainer, Colors.white, 0.35)!,
        Color.lerp(scheme.secondaryContainer, _sunrise, 0.5)!,
        scheme.tertiaryContainer.withValues(alpha: 0.92),
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    final heroShadow = [
      BoxShadow(
        color: scheme.primary.withValues(alpha: 0.14),
        blurRadius: 28,
        offset: const Offset(0, 18),
        spreadRadius: -8,
      ),
      BoxShadow(
        color: scheme.shadow.withValues(alpha: 0.06),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: scheme.surface,
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: backdropGradient),
              ),
            ),
            Positioned(
              top: -size.width * 0.15,
              right: -size.width * 0.22,
              child: _GlowOrb(
                diameter: size.width * 0.72,
                color: scheme.primary.withValues(alpha: 0.09),
              ),
            ),
            Positioned(
              top: size.height * 0.18,
              left: -size.width * 0.28,
              child: _GlowOrb(
                diameter: size.width * 0.55,
                color: scheme.tertiary.withValues(alpha: 0.08),
              ),
            ),
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  w * 0.065,
                  (topInset > 0 ? 6.0 : h * 0.022) + 4,
                  w * 0.065,
                  h * 0.022 + h * 0.02 + h * 0.032,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: w * 0.92),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BrandStrip(scheme: scheme),
                        SizedBox(height: h * 0.028),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(w * 0.09),
                              bottom: Radius.circular(w * 0.09),
                            ),
                            boxShadow: heroShadow,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(w * 0.09),
                              bottom: Radius.circular(w * 0.09),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(gradient: heroGradient),
                              child: SizedBox(
                                height: h * 0.38,
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    w * 0.065,
                                    18,
                                    w * 0.065,
                                    8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AnimatedSwitcher(
                                        duration: transitionDuration,
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        child: Text(
                                          _authHeadline(isLogin),
                                          key: ValueKey<String>(
                                            'headline_$isLogin',
                                          ),
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -1.0,
                                                height: 1.05,
                                                color:
                                                    scheme.onPrimaryContainer,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      AnimatedSwitcher(
                                        duration: transitionDuration,
                                        switchInCurve: Curves.easeOut,
                                        switchOutCurve: Curves.easeIn,
                                        child: Text(
                                          _authSubtitle(isLogin),
                                          key: ValueKey<bool>(isLogin),
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                color: scheme.onPrimaryContainer
                                                    .withValues(alpha: 0.82),
                                                height: 1.35,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: artboard != null
                                              ? Rive(
                                                  artboard: artboard!,
                                                  fit: BoxFit.contain,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                )
                                              : Center(
                                                  child: SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          color: scheme.primary,
                                                        ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -h * 0.032),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(w * 0.065 + 6),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: scheme.surface.withValues(alpha: 0.78),
                                  borderRadius: BorderRadius.circular(
                                    w * 0.065 + 6,
                                  ),
                                  border: Border.all(
                                    color: scheme.outlineVariant.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.shadow.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 32,
                                      offset: const Offset(0, 16),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    w * 0.055,
                                    h * 0.032 + 4,
                                    w * 0.055,
                                    h * 0.032 * 0.92,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: AuthModeTransition(
                                      isLogin: isLogin,
                                      duration: transitionDuration,
                                      signIn: SignInWidget(
                                        formKey: _formKey,
                                        emailControler: _emailController,
                                        passwordControler: _passwordController,
                                        onEmailFocusChanged:
                                            _onEmailFocusChanged,
                                        onEmailTextChanged: moveEyes,
                                        onPasswordFocusChanged:
                                            _onPasswordFocusChanged,
                                      ),
                                      signUp: SignUpWidget(
                                        formKey: _formKey,
                                        emailControler: _emailController,
                                        passwordControler: _passwordController,
                                        passwordConfirmationControler:
                                            _passwordConfirmationController,
                                        onEmailFocusChanged:
                                            _onEmailFocusChanged,
                                        onEmailTextChanged: moveEyes,
                                        onPasswordAreaFocusChanged:
                                            _onPasswordFocusChanged,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _authHeadline(bool isLogin) {
    return isLogin ? 'Hey again!' : 'New friend?';
  }

  String _authSubtitle(bool isLogin) {
    return isLogin
        ? 'Your bear missed you — sign in below.'
        : 'Create an account and say hello.';
  }
}

class _BrandStrip extends StatelessWidget {
  const _BrandStrip({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
          ),
          child: Icon(Icons.pets_rounded, color: scheme.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Training',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  color: scheme.onSurface,
                ),
              ),
              TextSpan(
                text: ' · cozy login',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
