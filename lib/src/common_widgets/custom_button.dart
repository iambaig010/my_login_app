import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: textColor,
              )
            : Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16.0),
              ),
      ),
    );
  }
}
