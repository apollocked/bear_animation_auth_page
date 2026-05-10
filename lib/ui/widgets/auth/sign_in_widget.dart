import 'package:bear_animation_auth_pages/Providers/auth_page_change_provider.dart';
import 'package:bear_animation_auth_pages/ui/widgets/custom_button.dart';
import 'package:bear_animation_auth_pages/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    super.key,
    required this.formKey,
    required this.emailControler,
    required this.passwordControler,
    required this.onEmailFocusChanged,
    required this.onEmailTextChanged,
    required this.onPasswordFocusChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailControler;
  final TextEditingController passwordControler;
  final ValueChanged<bool> onEmailFocusChanged;
  final ValueChanged<String> onEmailTextChanged;
  final ValueChanged<bool> onPasswordFocusChanged;

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
            Icon(Icons.lock_outline_rounded, size: 22, color: scheme.primary),
            const SizedBox(width: 10),
            Text(
              'Your credentials',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                letterSpacing: -0.35,
              ),
            ),
          ],
        ),
        SizedBox(height: h * 0.028),
        CustomTextField(
          label: 'Email',
          hint: 'you@example.com',
          controller: emailControler,
          validator: _emailValidator,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFocusChange: onEmailFocusChanged,
          onChanged: onEmailTextChanged,
        ),
        SizedBox(height: h * 0.018),
        CustomTextField(
          label: 'Password',
          hint: 'At least 8 characters',
          controller: passwordControler,
          textInputAction: TextInputAction.done,
          showPasswordVisibilityToggle: true,
          onFocusChange: onPasswordFocusChanged,
          validator: (value) {
            if (emailControler.text.isEmpty) return null;
            if (value == null || value.trim().isEmpty) {
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        SizedBox(height: h * 0.03),
        CustomButton(
          label: 'Log in',
          icon: Icons.login_rounded,
          width: double.infinity,
          onPressed: () => formKey.currentState?.validate(),
        ),
        SizedBox(height: h * 0.02),

        Center(
          child: CustomButton(
            leadingText: "Don't have an account?",
            actionText: 'Sign up',
            onPressed: () =>
                context.read<AuthPageChangeProvider>().changeWidget(),
          ),
        ),
      ],
    );
  }
}
