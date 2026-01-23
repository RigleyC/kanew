import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, danger, ghost }

enum ButtonSize { xs, sm, md, lg }

class KanbnButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final bool disabled;
  final Widget? iconLeft;
  final Widget? iconRight;
  final bool iconOnly;

  const KanbnButton({
    super.key,
    this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.fullWidth = false,
    this.disabled = false,
    this.iconLeft,
    this.iconRight,
    this.iconOnly = false,
  }) : assert(
         iconOnly ? label == null : true,
         'Botões iconOnly não devem ter label',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Definição das Cores baseadas no Tema
    Color backgroundColor;
    Color contentColor;
    Color? borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.12)
            : colorScheme.primary;
        contentColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : colorScheme.onPrimary;
        break;
      case ButtonVariant.secondary:
        backgroundColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.12)
            : colorScheme.surface;
        contentColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : colorScheme.onSurface;
        borderColor = disabled ? Colors.transparent : colorScheme.outline;
        break;
      case ButtonVariant.danger:
        backgroundColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.12)
            : colorScheme.error;
        contentColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : colorScheme.onError;
        borderColor = disabled ? Colors.transparent : colorScheme.error;
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        contentColor = disabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : colorScheme.onSurface;
        break;
    }

    return Opacity(
      opacity: (disabled || isLoading) ? 0.7 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (disabled || isLoading) ? null : onPressed,
          borderRadius: BorderRadius.circular(6),
          overlayColor: WidgetStateProperty.all(
            contentColor.withValues(alpha: 0.1),
          ),
          child: Container(
            width: fullWidth ? double.infinity : null,
            padding: _getPadding(),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
              border: borderColor != null
                  ? Border.all(color: borderColor, width: 1)
                  : null,
            ),
            child: _buildContent(theme, contentColor),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    if (iconOnly) {
      double s;
      switch (size) {
        case ButtonSize.xs:
          s = 24;
          break;
        case ButtonSize.sm:
          s = 32;
          break;
        case ButtonSize.lg:
          s = 40;
          break;
        case ButtonSize.md:
          s = 36;
          break;
      }
      return EdgeInsets.all((s - 24) / 2).copyWith(top: 0, bottom: 0);
    }

    switch (size) {
      case ButtonSize.xs:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
  }

  Widget _buildContent(ThemeData theme, Color contentColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: contentColor,
        ),
      );
    }

    final textStyle = theme.textTheme.labelLarge?.copyWith(
      color: contentColor,
      fontWeight: FontWeight.w600,
      fontSize: (size == ButtonSize.xs || size == ButtonSize.sm) ? 12 : 14,
    );

    if (iconOnly) {
      return Center(
        child: IconTheme(
          data: IconThemeData(color: contentColor, size: 18),
          child: iconLeft ?? iconRight ?? const SizedBox(),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconLeft != null) ...[
          IconTheme(
            data: IconThemeData(color: contentColor, size: 18),
            child: iconLeft!,
          ),
          const SizedBox(width: 8),
        ],
        if (label != null)
          Text(
            label!,
            style: textStyle,
          ),
        if (iconRight != null) ...[
          const SizedBox(width: 4),
          IconTheme(
            data: IconThemeData(color: contentColor, size: 18),
            child: iconRight!,
          ),
        ],
      ],
    );
  }
}
