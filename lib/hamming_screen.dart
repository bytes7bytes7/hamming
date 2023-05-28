import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hamming/hamming_bloc.dart';
import 'word_to_bit/word_to_bit_bloc.dart';

const _paddingH = 20.0;
const _snackBarDuration = Duration(seconds: 2);

class HammingScreen extends StatelessWidget {
  const HammingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HammingBloc>(
          create: (context) => HammingBloc(),
        ),
        BlocProvider<WordToBitBloc>(
          create: (context) => WordToBitBloc(),
        ),
      ],
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

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final hammingBloc = context.read<HammingBloc>();
    final wordToBitBloc = context.read<WordToBitBloc>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return BlocListener<HammingBloc, HammingState>(
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
      child: BlocListener<WordToBitBloc, WordToBitState>(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<HammingBloc, HammingState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: _paddingH,
                          vertical: 10,
                        ),
                        color: Colors.lightBlue,
                        child: const Text(
                          'Hamming',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _paddingH,
                        ),
                        child: Column(
                          children: [
                            _InputField(
                              onChanged: (v) => hammingBloc
                                  .add(SetInputHammingEvent(input: v)),
                              onCopyPressed: () => hammingBloc
                                  .add(const PasteToInputHammingEvent()),
                            ),
                            _Actions(
                              onEncodePressed: () =>
                                  hammingBloc.add(const EncodeHammingEvent()),
                              onDecodePressed: () =>
                                  hammingBloc.add(const DecodeHammingEvent()),
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
                            _ResultField(
                              result: state.result,
                              onCopyPressed: () => hammingBloc
                                  .add(const CopyResultHammingEvent()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              BlocBuilder<WordToBitBloc, WordToBitState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: _paddingH,
                          vertical: 10,
                        ),
                        color: Colors.lightBlue,
                        child: const Text(
                          'ASCII',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _paddingH,
                        ),
                        child: Column(
                          children: [
                            _InputField(
                              onChanged: (v) => wordToBitBloc
                                  .add(SetInputWordToBitEvent(input: v)),
                              onCopyPressed: () => wordToBitBloc
                                  .add(const PasteToInputWordToBitEvent()),
                            ),
                            _Actions(
                              onEncodePressed: () => wordToBitBloc
                                  .add(const EncodeWordToBitEvent()),
                              onDecodePressed: () => wordToBitBloc
                                  .add(const DecodeWordToBitEvent()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _ResultField(
                              result: state.result,
                              onCopyPressed: () => wordToBitBloc
                                  .add(const CopyResultWordToBitEvent()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.onChanged,
    required this.onCopyPressed,
  });

  final void Function(String) onChanged;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Input',
          suffixIcon: IconButton(
            onPressed: onCopyPressed,
            icon: const Icon(Icons.paste),
          ),
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.onEncodePressed,
    required this.onDecodePressed,
  });

  final VoidCallback onEncodePressed;
  final VoidCallback onDecodePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onEncodePressed,
          child: const Text('Encode'),
        ),
        ElevatedButton(
          onPressed: onDecodePressed,
          child: const Text('Decode'),
        ),
      ],
    );
  }
}

class _ResultField extends StatelessWidget {
  const _ResultField({
    required this.result,
    required this.onCopyPressed,
  });

  final String result;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            result,
          ),
        ),
        IconButton(
          onPressed: onCopyPressed,
          icon: const Icon(Icons.copy),
        ),
      ],
    );
  }
}
