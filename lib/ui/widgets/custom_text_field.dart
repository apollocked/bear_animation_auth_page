import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.showPasswordVisibilityToggle = false,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onFocusChange,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;

  final bool showPasswordVisibilityToggle;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChange;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.showPasswordVisibilityToggle ? true : widget.obscureText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.showPasswordVisibilityToggle &&
        oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  bool get _effectiveObscure =>
      widget.showPasswordVisibilityToggle ? _obscured : widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final w = sz.width;
    final h = sz.height;
    final fill = Color.alphaBlend(
      scheme.surfaceContainerLow.withValues(alpha: 0.65),
      scheme.surface.withValues(alpha: 0.5),
    );
    final r = BorderRadius.circular(w * 0.038);

    Widget? suffix = widget.suffixIcon;
    if (suffix == null && widget.showPasswordVisibilityToggle) {
      suffix = IconButton(
        onPressed: () => setState(() => _obscured = !_obscured),
        iconSize: w * 0.06,
        style: IconButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
          ),
        ),
        SizedBox(height: h * 0.01),
        Focus(
          onFocusChange: widget.onFocusChange,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _effectiveObscure,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.72),
              ),
              filled: true,
              fillColor: fill,
              suffixIcon: suffix,
              border: OutlineInputBorder(borderRadius: r),
              enabledBorder: OutlineInputBorder(
                borderRadius: r,
                borderSide: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: r,
                borderSide: BorderSide(color: scheme.primary, width: w * 0.014),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: r,
                borderSide: BorderSide(color: scheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: r,
                borderSide: BorderSide(color: scheme.error, width: w * 0.012),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
