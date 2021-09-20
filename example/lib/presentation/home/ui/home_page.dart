import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core_example/presentation/home/ui/bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
   // context.read<HomeCubit>().callWithCustomError();
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
          body: CoreUpgradeBlocBuilder<HomeCubit, CoreState>(
        notInternetConnectionBuilder: (context, state) {
          return Center(
            child: InkWell(
              onTap: () {
                context.read<HomeCubit>().callWithCustomError();
              },
              child: Text("Нет интернет соеденения"),
            ),
          );
        },
        errorBuilder: (context, state) {
          return Center(
            child: InkWell(
              onTap: () {
                context.read<HomeCubit>().callWithCustomError();
              },
              child: Text("Произошла ошибка"),
            ),
          );
        },
        builder: (context, state) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    context.read<HomeCubit>().callWithCustomError();
                  },
                  child: Center(
                    child: Text("Click me custom error"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<HomeCubit>().call();
                  },
                  child: Center(
                    child: Text("Click me"),
                  ),
                )
              ],
            ),
          );
        },
      ));
}
