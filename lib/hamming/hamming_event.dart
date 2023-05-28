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

class SetInterpretAsWordHammingEvent extends HammingEvent {
  const SetInterpretAsWordHammingEvent({
    required this.value,
  });

  final bool value;

  @override
  List<Object?> get props => [value];
}

class EncodeHammingEvent extends HammingEvent {
  const EncodeHammingEvent();
}

class DecodeHammingEvent extends HammingEvent {
  const DecodeHammingEvent();
}

class CopyResultHammingEvent extends HammingEvent {
  const CopyResultHammingEvent();
}

class PasteToInputHammingEvent extends HammingEvent {
  const PasteToInputHammingEvent();
}
