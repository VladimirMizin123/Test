import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../constant/app_colors.dart';

class BlocDemo extends StatelessWidget {
  const BlocDemo({super.key});

  @override
  Widget build(BuildContext context) {
    BlocClass bloc = BlocClass();
    Color color = AppColors.letsEatButton;
    return Scaffold(
      body: Center(
        child: BlocConsumer(
            bloc: bloc,
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  bloc.add(ClickEvent());
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color),),
                child: const Text('Click'),
              );
            },
            listener: (context, state) {
              color =  AppColors.appColor;
            }),
      ),
    );
  }
}
