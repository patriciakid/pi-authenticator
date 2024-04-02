abstract class ProcessorResult<T> {
  const ProcessorResult();
  factory ProcessorResult.success(T data) => ProcessorResultSuccess(data);
  factory ProcessorResult.error(String errorMessage) => ProcessorResultError(errorMessage);
}

class ProcessorResultSuccess<T> implements ProcessorResult<T> {
  final T resultData;
  const ProcessorResultSuccess(this.resultData);

  @override
  String toString() {
    return 'ProcessorResultSuccess(data: $resultData)';
  }
}

class ProcessorResultError<T> implements ProcessorResult<T> {
  final String errorMessage;
  const ProcessorResultError(this.errorMessage);

  @override
  String toString() {
    return 'ProcessorResultError(errorMessage: $errorMessage)';
  }
}
