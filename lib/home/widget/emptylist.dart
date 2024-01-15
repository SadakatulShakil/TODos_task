import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
/// Empty List State
class EmptyListState extends StatelessWidget {
  const EmptyListState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: FadeInUp(
                from: 30,
                child: Lottie.asset(
                    fit: BoxFit.cover,
                    'assets/images/empty_screen.json')),
          ),
          const SizedBox(
            height: 50,
          ),
          FadeInUp(
            from: 30,
            child: const Text(
              "All Tasks Done!👍",
              style: TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          FadeInUp(
            from: 30,
            delay: const Duration(milliseconds: 400),
            child: Text(
              "For Creating a Task Tap on the FAB button👇",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}