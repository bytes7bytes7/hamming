import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hamming_event.dart';

part 'hamming_state.dart';

class HammingBloc extends Bloc<HammingEvent, HammingState> {
  HammingBloc() : super(const HammingState()) {
    on<SetInputHammingEvent>(_setInput);
    on<EncodeHammingEvent>(_encode);
    on<DecodeHammingEvent>(_decode);
    on<CopyFromClipboardResultHammingEvent>(_copyResult);
    on<PasteToInputHammingEvent>(_pasteToInput);
  }

  void _setInput(
    SetInputHammingEvent event,
    Emitter<HammingState> emit,
  ) {
    emit(
      state.copyWith(
        input: event.input,
      ),
    );
  }

  void _encode(
    EncodeHammingEvent event,
    Emitter<HammingState> emit,
  ) {
    try {
      final input = state.input.split('').map(int.parse).toList();
      final output = <int>[];
      final powerOf2Indexes = <int>[];

      var inputIndex = 0;
      var outputIndex = 0;
      while (inputIndex < input.length) {
        if (_isPowerOf2(_log2(outputIndex + 1))) {
          output.add(0);
          powerOf2Indexes.add(outputIndex);
        } else {
          output.add(input[inputIndex]);
          inputIndex++;
        }

        outputIndex++;
      }

      for (final pow2Index in powerOf2Indexes) {
        final len = pow2Index + 1;

        var res = 0;
        var reachEnd = false;
        for (var offset = pow2Index;
            offset < output.length;
            offset += len * 2) {
          for (var i = offset; i < offset + len; i++) {
            if (i >= output.length) {
              reachEnd = true;
              break;
            }

            res ^= output[i];
          }

          if (reachEnd) {
            break;
          }
        }

        output[pow2Index] = res;
      }

      emit(
        state.copyWith(
          result: output.join(''),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Ошибка при кодировании',
        ),
      );

      emit(state.copyWith());
    }
  }

  void _decode(
    DecodeHammingEvent event,
    Emitter<HammingState> emit,
  ) {
    try {
      final input = state.input.split('').map(int.parse).toList();
      final checking = List.of(input);
      final powerOf2Indexes = <int>[];

      for (var i = 0; i < checking.length; i++) {
        if (_isPowerOf2(_log2(i + 1))) {
          checking[i] = 0;
          powerOf2Indexes.add(i);
        }
      }

      for (final pow2Index in powerOf2Indexes) {
        final len = pow2Index + 1;

        var res = 0;
        var reachEnd = false;
        for (var offset = pow2Index;
            offset < checking.length;
            offset += len * 2) {
          for (var i = offset; i < offset + len; i++) {
            if (i >= checking.length) {
              reachEnd = true;
              break;
            }

            res ^= checking[i];
          }

          if (reachEnd) {
            break;
          }
        }

        checking[pow2Index] = res;
      }

      final errorPositions = <int>[];
      for (final pow2Index in powerOf2Indexes) {
        final actual = input[pow2Index];
        final expected = checking[pow2Index];

        if (actual != expected) {
          errorPositions.add(pow2Index + 1);
        }
      }

      if (errorPositions.isNotEmpty) {
        final errorPosition =
            errorPositions.reduce((prev, curr) => prev + curr);

        final errorIndex = errorPosition - 1;
        final value = input[errorIndex];
        input[errorIndex] = value == 1 ? 0 : 1;

        emit(
          state.copyWith(
            errorBitIndex: '$errorIndex',
          ),
        );
      }

      final output = <int>[];
      for (var i = 0; i < input.length; i++) {
        if (!_isPowerOf2(_log2(i + 1))) {
          output.add(input[i]);
        }
      }

      emit(
        state.copyWith(
          result: output.join(''),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Ошибка при декодировании',
        ),
      );

      emit(state.copyWith());
    }
  }

  Future<void> _copyResult(
    CopyFromClipboardResultHammingEvent event,
    Emitter<HammingState> emit,
  ) async {
    await Clipboard.setData(ClipboardData(text: state.result));

    emit(
      state.copyWith(
        isResultCopied: true,
      ),
    );
  }

  Future<void> _pasteToInput(
    PasteToInputHammingEvent event,
    Emitter<HammingState> emit,
  ) async {
    final value = await Clipboard.getData('text/plain');

    final text = value?.text;
    if (text != null) {
      emit(state.copyWith(input: text));
    }
  }

  bool _isPowerOf2(num n) => n == n.roundToDouble();

  num _log2(num x) => log(x) / log(2);
}
