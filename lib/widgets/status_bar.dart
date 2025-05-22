import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _buildSignalIcon(),
              const SizedBox(width: 4),
              _buildWifiIcon(),
              const SizedBox(width: 4),
              _buildBatteryIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalIcon() {
    return Container(
      width: 16,
      height: 16,
      child: CustomPaint(
        painter: SignalPainter(),
      ),
    );
  }

  Widget _buildWifiIcon() {
    return Container(
      width: 16,
      height: 16,
      child: CustomPaint(
        painter: WifiPainter(),
      ),
    );
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 24,
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}

class SignalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double width = size.width;
    final double height = size.height;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(width / 2, height / 2), width: width, height: height),
      0,
      3.14 * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WifiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double width = size.width;
    final double height = size.height;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(width / 2, height / 2), width: width, height: height),
      0,
      3.14 * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}