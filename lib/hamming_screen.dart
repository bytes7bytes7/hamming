import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'hamming/hamming_bloc.dart';

const _snackBarDuration = Duration(seconds: 2);

class HammingScreen extends StatelessWidget {
  const HammingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HammingBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Hamming Code'),
            ),
            body: const _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HammingBloc>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final inputController = useTextEditingController();

    return BlocConsumer<HammingBloc, HammingState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              duration: _snackBarDuration,
              content: Text(
                state.error,
              ),
            ),
          );
        }

        if (state.isResultCopied) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              duration: _snackBarDuration,
              content: Text(
                'Result is copied!',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: TextField(
                  controller: inputController,
                  onChanged: (v) => bloc.add(SetInputHammingEvent(input: v)),
                  decoration: InputDecoration(
                    labelText: 'Input',
                    suffixIcon: IconButton(
                      onPressed: () =>
                          bloc.add(const PasteToInputHammingEvent()),
                      icon: const Icon(Icons.paste),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => bloc.add(const EncodeHammingEvent()),
                    child: const Text('Encode'),
                  ),
                  ElevatedButton(
                    onPressed: () => bloc.add(const DecodeHammingEvent()),
                    child: const Text('Decode'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (state.hasErrorBit)
                Text(
                  'Fixed error on ${state.errorBitIndex} index',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Result: ',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      state.result,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        bloc.add(const CopyFromClipboardResultHammingEvent()),
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
