import 'package:flutter/material.dart';

const Color green = Color(0xFF1C5C35);
const Color green3 = Color(0xFFE8F5EE);
const Color amber = Color(0xFFF5A100);
const Color amberBg = Color(0xFFFFF7E6);
const Color bg = Color(0xFFF7F4EF);
const Color txt = Color(0xFF1A1A1A);
const Color txt2 = Color(0xFF333333);
const Color txt3 = Color(0xFF777777);
const Color danger = Color(0xFFE53935);
const Color info = Color(0xFF1565C0);
const double rad = 14;
const double radButton = 16;
const Color border = Color(0xFFE0DCD6);
const Color borderLight = Color(0xFFF0ECE6);

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0DCD6), width: 1.5),
          color: Colors.white,
        ),
        child: const Center(child: Icon(Icons.chevron_left, size: 20, color: txt)),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  const PageHeader({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          AppBackButton(onPressed: onBack),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool loading;
  final EdgeInsetsGeometry? padding;
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.loading = false,
    this.padding,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.disabled || widget.loading
              ? null
              : () {
                  _controller.forward().then((_) => _controller.reverse());
                  widget.onPressed?.call();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.disabled ? txt3 : green,
            disabledBackgroundColor: txt3,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radButton)),
            padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            elevation: widget.disabled ? 0 : 2,
            shadowColor: green.withValues(alpha: 0.3),
          ),
          child: widget.loading
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)),
                    SizedBox(width: 8),
                    Text('Processing...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                )
              : Text(widget.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class OutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  const OutlineButton({super.key, required this.text, this.onPressed});

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            _controller.forward().then((_) => _controller.reverse());
            widget.onPressed?.call();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: green,
            side: const BorderSide(color: green, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radButton)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
          child: Text(widget.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class FormInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? margin;
  final Widget? prefix;
  final bool enabled;
  const FormInput({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.margin,
    this.prefix,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: [
          if (prefix != null) ...[prefix!, const SizedBox(width: 8)],
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: keyboardType,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: txt3, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radButton),
                  borderSide: const BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radButton),
                  borderSide: const BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radButton),
                  borderSide: const BorderSide(color: green, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 15, color: txt),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  const SectionCard({super.key, this.title, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: const Color(0xFFE8E4DF), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txt2, letterSpacing: 0.6)),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

class QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool small;
  const QtyControl({super.key, required this.qty, required this.onAdd, required this.onRemove, this.small = false});

  @override
  Widget build(BuildContext context) {
    final size = small ? 28.0 : 32.0;
    if (qty == 0) {
      return GestureDetector(
        onTap: onAdd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size, height: size,
          decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(10)),
          child: const Center(child: Text('+', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: green3,
        border: Border.all(color: green, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: size, height: size,
              alignment: Alignment.center,
              child: const Text('\u2212', style: TextStyle(color: green, fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
          SizedBox(
            width: small ? 18 : 22,
            child: Text('$qty', textAlign: TextAlign.center, style: TextStyle(fontSize: small ? 12 : 13, fontWeight: FontWeight.w700, color: green)),
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: size, height: size,
              alignment: Alignment.center,
              child: const Text('+', style: TextStyle(color: green, fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final String active;
  final ValueChanged<String> onNavigate;
  const BottomNav({super.key, required this.active, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('home', 'Home', Icons.home_outlined, Icons.home),
      ('orders', 'Orders', Icons.description_outlined, Icons.description),
      ('loyalty', 'Loyalty', Icons.card_giftcard_outlined, Icons.card_giftcard),
      ('profile', 'Profile', Icons.person_outline, Icons.person),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final isActive = active == item.$1;
          return GestureDetector(
            onTap: () => onNavigate(item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isActive ? item.$4 : item.$3, size: 22, color: isActive ? green : txt3),
                  const SizedBox(height: 3),
                  Text(item.$2, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? green : txt3)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;
  const CategoryIcon({super.key, required this.icon, required this.label, required this.color, this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        child: Column(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isActive ? [color, color.withValues(alpha: 0.7)] : [color.withValues(alpha: 0.5), color.withValues(alpha: 0.2)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                border: Border.all(color: isActive ? green : Colors.transparent, width: 2.5),
                boxShadow: isActive
                    ? [BoxShadow(color: green.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 1)]
                    : [],
              ),
              child: Icon(icon, color: isActive ? green : txt2, size: 28),
            ),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? green : txt2)),
          ],
        ),
      ),
    );
  }
}
