import 'package:flutter/material.dart';

class PatternedBackground extends StatelessWidget {
  final Color dotColor;
  final Color backgroundColor;

  const PatternedBackground({
    super.key,
    this.dotColor = const Color(0xFF3e3e3e), // Cor extraída do arquivo original
    this.backgroundColor = Colors.transparent, // O original é transparente
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _DotPatternPainter(
          dotColor: dotColor,
          spacing: 14.42, // Valor extraído do 'width' do pattern no SVG
          radius: 0.45, // Valor extraído do 'r' do circle no SVG
        ),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  final Color dotColor;
  final double spacing;
  final double radius;

  _DotPatternPainter({
    required this.dotColor,
    required this.spacing,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Calcula quantos pontos cabem na largura e altura
    // Adiciona uma margem de segurança para garantir cobertura total
    final int countX = (size.width / spacing).ceil();
    final int countY = (size.height / spacing).ceil();

    // Desenha os pontos
    for (int i = 0; i <= countX; i++) {
      for (int j = 0; j <= countY; j++) {
        // O offset inicial (10, 10) e a translação do pattern no SVG original
        // resultam em um alinhamento específico. Aqui simplificamos para o grid.
        final double x = i * spacing;
        final double y = j * spacing;

        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor ||
        oldDelegate.spacing != spacing ||
        oldDelegate.radius != radius;
  }
}
