import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final bool visible;

  const ProgressBarWidget({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Center(
        child: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ],
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 4.5,
            color: Colors.blue,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
    );
  }
}
