part of 'word_to_bit_bloc.dart';

abstract class WordToBitEvent extends Equatable {
  const WordToBitEvent();

  @override
  List<Object?> get props => [];
}

class SetInputWordToBitEvent extends WordToBitEvent {
  const SetInputWordToBitEvent({required this.input});

  final String input;

  @override
  List<Object?> get props => [input];
}

class EncodeWordToBitEvent extends WordToBitEvent {
  const EncodeWordToBitEvent();
}

class DecodeWordToBitEvent extends WordToBitEvent {
  const DecodeWordToBitEvent();
}

class CopyResultWordToBitEvent extends WordToBitEvent {
  const CopyResultWordToBitEvent();
}

class PasteToInputWordToBitEvent extends WordToBitEvent {
  const PasteToInputWordToBitEvent();
}
