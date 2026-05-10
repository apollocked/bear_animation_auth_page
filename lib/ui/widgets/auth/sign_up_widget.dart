import 'package:bear_animation_auth_pages/Providers/auth_page_change_provider.dart';
import 'package:bear_animation_auth_pages/ui/widgets/custom_button.dart';
import 'package:bear_animation_auth_pages/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    required this.formKey,
    required this.emailControler,
    required this.passwordControler,
    required this.passwordConfirmationControler,
    required this.onEmailFocusChanged,
    required this.onEmailTextChanged,
    required this.onPasswordAreaFocusChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailControler;
  final TextEditingController passwordControler;
  final TextEditingController passwordConfirmationControler;
  final ValueChanged<bool> onEmailFocusChanged;
  final ValueChanged<String> onEmailTextChanged;
  final ValueChanged<bool> onPasswordAreaFocusChanged;

  static String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool _passwordFocused = false;
  bool _confirmPasswordFocused = false;

  void _onPasswordFieldFocus(int index, bool hasFocus) {
    setState(() {
      if (index == 0) {
        _passwordFocused = hasFocus;
      } else {
        _confirmPasswordFocused = hasFocus;
      }
    });
    if (hasFocus) {
      widget.onPasswordAreaFocusChanged(true);
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onPasswordAreaFocusChanged(
        _passwordFocused || _confirmPasswordFocused,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final h = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.how_to_reg_outlined, size: 22, color: scheme.primary),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Set up your profile',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  letterSpacing: -0.35,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: h * 0.028),
        CustomTextField(
          label: 'Email',
          hint: 'you@example.com',
          controller: widget.emailControler,
          validator: SignUpWidget._emailValidator,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFocusChange: widget.onEmailFocusChanged,
          onChanged: widget.onEmailTextChanged,
        ),
        SizedBox(height: h * 0.018),
        CustomTextField(
          label: 'Password',
          hint: 'At least 8 characters',
          controller: widget.passwordControler,
          textInputAction: TextInputAction.next,
          showPasswordVisibilityToggle: true,
          onFocusChange: (has) => _onPasswordFieldFocus(0, has),
          validator: (value) {
            if (widget.emailControler.text.isEmpty) return null;
            if (value == null || value.trim().isEmpty) {
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        SizedBox(height: h * 0.018),
        CustomTextField(
          label: 'Confirm password',
          hint: 'Repeat your password',
          controller: widget.passwordConfirmationControler,
          textInputAction: TextInputAction.done,
          showPasswordVisibilityToggle: true,
          onFocusChange: (has) => _onPasswordFieldFocus(1, has),
          validator: (value) {
            if (widget.passwordControler.text.isEmpty) return null;
            if (value == null || value.trim().isEmpty) {
              return 'Please confirm your password';
            }
            if (value != widget.passwordControler.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        SizedBox(height: h * 0.03),
        CustomButton(
          label: 'Sign up',
          icon: Icons.person_add_alt_1_rounded,
          width: double.infinity,
          onPressed: () => widget.formKey.currentState?.validate(),
        ),
        SizedBox(height: h * 0.02),
        Center(
          child: CustomButton(
            leadingText: 'Already have an account?',
            actionText: 'Log in',
            onPressed: () =>
                context.read<AuthPageChangeProvider>().changeWidget(),
          ),
        ),
      ],
    );
  }
}
