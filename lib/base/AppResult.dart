



class AppResult<T>{

  T? data;
  AppResult(this.data);
  factory AppResult.success(T data) => AppResultSuccess(data);
  factory AppResult.error( Exception? ex , [ T? data]) => AppResultError(ex , data );

  bool get isSuccess => this is AppResultSuccess;
  bool get isError => this is AppResultError;

  T? get value => (this as AppResultSuccess<T>?)?.data;
  Exception? get error => (this as AppResultError<T>?)?.ex;

}

class AppResultSuccess<T> extends AppResult<T>{
  AppResultSuccess(super.data);
}

class AppResultError<T> extends AppResult<T>{
  final Exception? ex;
  AppResultError(this.ex , super.data);
}
