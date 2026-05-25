import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final Widget? rightWidget;

  const CommonHeader({super.key, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "AdLoop",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          /// Optional right side (like Register button)
          if (rightWidget != null) rightWidget!,
        ],
      ),
    );
  }
}