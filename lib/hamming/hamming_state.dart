part of 'hamming_bloc.dart';

class HammingState extends Equatable {
  const HammingState({
    this.error = '',
    this.input = '',
    this.result = '',
    this.errorBitIndex = '',
    this.isResultCopied = false,
  });

  final String error;
  final String input;
  final String result;
  final String errorBitIndex;
  final bool isResultCopied;

  bool get hasErrorBit => errorBitIndex.isNotEmpty;

  HammingState copyWith({
    String? error = '',
    String? input,
    String? result,
    String? errorBitIndex,
    bool? isResultCopied = false,
  }) {
    return HammingState(
      error: error ?? this.error,
      input: input ?? this.input,
      result: result ?? this.result,
      errorBitIndex: errorBitIndex ?? this.errorBitIndex,
      isResultCopied: isResultCopied ?? this.isResultCopied,
    );
  }

  @override
  List<Object?> get props => [
        error,
        input,
        result,
        errorBitIndex,
        isResultCopied,
      ];
}
