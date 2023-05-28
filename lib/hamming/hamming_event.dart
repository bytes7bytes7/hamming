part of 'hamming_bloc.dart';

abstract class HammingEvent extends Equatable {
  const HammingEvent();

  @override
  List<Object?> get props => [];
}

class SetInputHammingEvent extends HammingEvent {
  const SetInputHammingEvent({
    required this.input,
  });

  final String input;

  @override
  List<Object?> get props => [input];
}

class EncodeHammingEvent extends HammingEvent {
  const EncodeHammingEvent();
}

class DecodeHammingEvent extends HammingEvent {
  const DecodeHammingEvent();
}

class CopyFromClipboardResultHammingEvent extends HammingEvent {
  const CopyFromClipboardResultHammingEvent();
}

class PasteToInputHammingEvent extends HammingEvent {
  const PasteToInputHammingEvent();
}
