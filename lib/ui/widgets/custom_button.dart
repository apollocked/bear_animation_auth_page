import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.width,
    this.leadingText,
    this.actionText,
  }) : assert(
         (label != null && leadingText == null && actionText == null) ||
             (label == null && leadingText != null && actionText != null),
         'Use label for a filled button, or leadingText + actionText for a link row.',
       );

  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final double? width;
  final String? leadingText;
  final String? actionText;

  bool get _isLink => leadingText != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final w = sz.width;
    final h = sz.height;

    if (_isLink) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: w * 0.018,
        runSpacing: w * 0.018 * 0.5,
        alignment: WrapAlignment.center,
        children: [
          Text(
            leadingText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.022,
                vertical: h * 0.007,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: scheme.primary,
            ),
            child: Text(
              actionText!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    }

    final rowChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label!,
          style: theme.textTheme.titleSmall?.copyWith(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        if (icon != null) ...[
          SizedBox(width: w * 0.02),
          Icon(icon, size: w * 0.055, color: scheme.onPrimary),
        ],
      ],
    );

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        scheme.primary,
        Color.lerp(scheme.primary, scheme.tertiary, 0.42)!,
      ],
    );

    final radius = BorderRadius.circular(w * 0.038);

    final shadow = onPressed == null
        ? null
        : [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.34),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ];

    return SizedBox(
      width: width,
      height: h * 0.07,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: onPressed == null
                      ? LinearGradient(
                          colors: [
                            scheme.surfaceContainerHighest,
                            scheme.surfaceContainerHigh,
                          ],
                        )
                      : gradient,
                ),
                child: Center(
                  child: onPressed == null
                      ? IconTheme.merge(
                          data: IconThemeData(color: scheme.onSurfaceVariant),
                          child: DefaultTextStyle.merge(
                            style: TextStyle(color: scheme.onSurfaceVariant),
                            child: rowChild,
                          ),
                        )
                      : rowChild,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
