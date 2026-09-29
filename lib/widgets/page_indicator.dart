import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {

  final int itemCount;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(
        itemCount,
        (index) {

          final bool isSelected =
              index == currentIndex;

          return AnimatedContainer(

            duration: const Duration(
              milliseconds: 250,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
            ),

            width: isSelected ? 45 : 10,
            height: 10,

            decoration: BoxDecoration(

              color: isSelected
                  ? const Color(0xFF7042A5)
                  : Colors.grey.shade300,

              borderRadius:
                  BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}