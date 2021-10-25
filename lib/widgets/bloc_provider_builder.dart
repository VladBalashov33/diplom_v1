import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviderBuilder<B extends BlocBase<S>, S> extends StatelessWidget {
  final B Function(BuildContext) create;
  final BlocWidgetBuilder<S> builder;

  const BlocProviderBuilder({
    required this.create,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: Builder(
        builder: (context) {
          return BlocBuilder<B, S>(
            builder: builder,
          );
        },
      ),
    );
  }
}

class BlocProviderConsumer<B extends BlocBase<S>, S> extends StatelessWidget {
  final B Function(BuildContext) create;
  final BlocWidgetListener<S> listener;
  final BlocWidgetBuilder<S> builder;

  const BlocProviderConsumer({
    required this.create,
    required this.listener,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: Builder(
        builder: (context) {
          return BlocConsumer<B, S>(
            listener: listener,
            builder: builder,
          );
        },
      ),
    );
  }
}
