part of 'word_to_bit_bloc.dart';

class WordToBitState extends Equatable {
  const WordToBitState({
    this.error = '',
    this.input = '',
    this.result = '',
    this.isResultCopied = false,
  });

  final String error;
  final String input;
  final String result;
  final bool isResultCopied;

  WordToBitState copyWith({
    String? error = '',
    String? input,
    String? result,
    bool? isResultCopied = false,
  }) {
    return WordToBitState(
      error: error ?? this.error,
      input: input ?? this.input,
      result: result ?? this.result,
      isResultCopied: isResultCopied ?? this.isResultCopied,
    );
  }

  @override
  List<Object?> get props => [
        error,
        input,
        result,
        isResultCopied,
      ];
}
