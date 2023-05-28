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
        return ListView(
          children: [
            SizedBox(
              height: 300,
              child: TextField(
                controller: inputController,
                onChanged: (v) => bloc.add(SetInputHammingEvent(input: v)),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => bloc.add(const PasteToInputHammingEvent()),
                    icon: const Icon(Icons.paste),
                  ),
                ),
              ),
            ),
            Row(
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
            if (state.hasErrorBit) Text(state.errorBitIndex),
            Row(
              children: [
                Text(state.result),
                IconButton(
                  onPressed: () =>
                      bloc.add(const CopyFromClipboardResultHammingEvent()),
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
