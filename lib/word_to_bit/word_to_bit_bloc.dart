import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_to_bit_event.dart';

part 'word_to_bit_state.dart';

class WordToBitBloc extends Bloc<WordToBitEvent, WordToBitState> {
  WordToBitBloc() : super(const WordToBitState()) {
    on<SetInputWordToBitEvent>(_setInput);
    on<EncodeWordToBitEvent>(_encode);
    on<DecodeWordToBitEvent>(_decode);
    on<CopyResultWordToBitEvent>(_copyResult);
    on<PasteToInputWordToBitEvent>(_pasteToInput);
  }

  void _setInput(
    SetInputWordToBitEvent event,
    Emitter<WordToBitState> emit,
  ) {
    emit(
      state.copyWith(
        input: event.input,
      ),
    );
  }

  void _encode(
    EncodeWordToBitEvent event,
    Emitter<WordToBitState> emit,
  ) {
    try {
      final bytes = ascii.encode(state.input);

      final buff = StringBuffer();
      for (final byte in bytes) {
        buff.write(byte.toRadixString(2).toString().padLeft(7, '0'));
      }

      emit(
        state.copyWith(
          result: buff.toString(),
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
    DecodeWordToBitEvent event,
    Emitter<WordToBitState> emit,
  ) {
    try {
      var input = state.input;

      if (input.length % 7 != 0) {
        throw Exception('Invalid string');
      }

      final bytes = <int>[];
      while (input.isNotEmpty) {
        final str = input.substring(0, 7);
        input = input.substring(7);
        bytes.add(int.parse(str, radix: 2));
      }

      emit(
        state.copyWith(
          result: ascii.decode(bytes),
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
    CopyResultWordToBitEvent event,
    Emitter<WordToBitState> emit,
  ) async {
    await Clipboard.setData(ClipboardData(text: state.result));

    emit(
      state.copyWith(
        isResultCopied: true,
      ),
    );

    emit(state.copyWith());
  }

  Future<void> _pasteToInput(
    PasteToInputWordToBitEvent event,
    Emitter<WordToBitState> emit,
  ) async {
    final value = await Clipboard.getData('text/plain');

    final text = value?.text;
    if (text != null) {
      emit(state.copyWith(input: text));
    }
  }
}
