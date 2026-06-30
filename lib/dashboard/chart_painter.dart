import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chartdata.dart';

class ChartPainter extends CustomPainter{
  final List<ChartData> data;
  ChartPainter(this.data);
  @override
  void paint(Canvas canvas, Size size){
    final paint1 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    final path2 = Path();

    double maxValue = data.map((e) => max(e.value1, e.value2 )).reduce(max);
    double stepX = size.width / (data.length - 1);

    for(int i = 0; i < data.length; i++){
      double x = i * stepX;
      double y1 = size.height - (data[i].value1/ maxValue)* size.height;
      double y2 = size.height - (data[i].value2/ maxValue)* size.height;

      if(i == 0){
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      }else{
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
