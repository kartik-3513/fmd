import 'package:flutter/material.dart';
import 'package:fmd/appStateProvider.dart';
import 'package:fmd/utils.dart';
import 'package:provider/provider.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback cameraSwitchCallback;
  final VoidCallback toggleDetectionCallback;
  const ControlButtons(
      {Key? key,
      required this.cameraSwitchCallback,
      required this.toggleDetectionCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.black),
          ),
          onPressed: cameraSwitchCallback,
          child: const Padding(
            padding:  EdgeInsets.all(8.0),
            child: Text(
              'Toggle Camera',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.black),
          ),
          onPressed: toggleDetectionCallback,
          child: Consumer<AppStateProvider>(
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.isDetecting ? 'Stop Detection' : 'Start Detection',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
