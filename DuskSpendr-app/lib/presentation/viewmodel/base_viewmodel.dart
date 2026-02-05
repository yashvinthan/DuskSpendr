import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base state class for UI screens
/// Uses sealed class pattern for exhaustive state handling
sealed class UiState<T> {
  const UiState();
}

/// Initial/idle state before any action
class UiStateIdle<T> extends UiState<T> {
  const UiStateIdle();
}

/// Loading state while fetching data
class UiStateLoading<T> extends UiState<T> {
  final String? message;
  const UiStateLoading([this.message]);
}

/// Success state with data
class UiStateSuccess<T> extends UiState<T> {
  final T data;
  const UiStateSuccess(this.data);
}

/// Error state with error details
class UiStateError<T> extends UiState<T> {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isRetryable;

  const UiStateError(
    this.message, {
    this.error,
    this.stackTrace,
    this.isRetryable = true,
  });
}

/// Empty state (success but no data)
class UiStateEmpty<T> extends UiState<T> {
  final String? message;
  const UiStateEmpty([this.message]);
}

/// Extension methods for UiState
extension UiStateExtension<T> on UiState<T> {
  /// Check if in loading state
  bool get isLoading => this is UiStateLoading;

  /// Check if in success state
  bool get isSuccess => this is UiStateSuccess;

  /// Check if in error state
  bool get isError => this is UiStateError;

  /// Check if in idle state
  bool get isIdle => this is UiStateIdle;

  /// Check if in empty state
  bool get isEmpty => this is UiStateEmpty;

  /// Get data if in success state, null otherwise
  T? get dataOrNull {
    if (this is UiStateSuccess<T>) {
      return (this as UiStateSuccess<T>).data;
    }
    return null;
  }

  /// Get error message if in error state
  String? get errorMessage {
    if (this is UiStateError<T>) {
      return (this as UiStateError<T>).message;
    }
    return null;
  }

  /// Map state to a widget using callbacks
  R when<R>({
    required R Function() idle,
    required R Function(String? message) loading,
    required R Function(T data) success,
    required R Function(String message, bool isRetryable) error,
    required R Function(String? message) empty,
  }) {
    return switch (this) {
      UiStateIdle() => idle(),
      UiStateLoading(:final message) => loading(message),
      UiStateSuccess(:final data) => success(data),
      UiStateError(:final message, :final isRetryable) => error(message, isRetryable),
      UiStateEmpty(:final message) => empty(message),
    };
  }

  /// Map state with default handlers for some states
  R maybeWhen<R>({
    R Function()? idle,
    R Function(String? message)? loading,
    R Function(T data)? success,
    R Function(String message, bool isRetryable)? error,
    R Function(String? message)? empty,
    required R Function() orElse,
  }) {
    return switch (this) {
      UiStateIdle() => idle?.call() ?? orElse(),
      UiStateLoading(:final message) => loading?.call(message) ?? orElse(),
      UiStateSuccess(:final data) => success?.call(data) ?? orElse(),
      UiStateError(:final message, :final isRetryable) =>
        error?.call(message, isRetryable) ?? orElse(),
      UiStateEmpty(:final message) => empty?.call(message) ?? orElse(),
    };
  }
}

/// Base class for ViewModels using Riverpod
/// Provides common functionality for all ViewModels
abstract class BaseNotifier<T> extends AutoDisposeNotifier<UiState<T>> {
  @override
  UiState<T> build() => const UiStateIdle();

  /// Set loading state
  void setLoading([String? message]) {
    state = UiStateLoading(message);
  }

  /// Set success state with data
  void setSuccess(T data) {
    state = UiStateSuccess(data);
  }

  /// Set error state
  void setError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool isRetryable = true,
  }) {
    state = UiStateError(
      message,
      error: error,
      stackTrace: stackTrace,
      isRetryable: isRetryable,
    );
  }

  /// Set empty state
  void setEmpty([String? message]) {
    state = UiStateEmpty(message);
  }

  /// Set idle state
  void setIdle() {
    state = const UiStateIdle();
  }

  /// Execute an async operation with automatic state management
  Future<void> execute(
    Future<T> Function() operation, {
    String? loadingMessage,
    String? errorMessage,
    String? emptyMessage,
    bool Function(T)? isEmpty,
  }) async {
    setLoading(loadingMessage);
    try {
      final result = await operation();
      if (isEmpty != null && isEmpty(result)) {
        setEmpty(emptyMessage);
      } else {
        setSuccess(result);
      }
    } catch (e, st) {
      setError(
        errorMessage ?? e.toString(),
        error: e,
        stackTrace: st,
      );
    }
  }
}

/// Async version for operations that need to load data on build
abstract class BaseAsyncNotifier<T> extends AutoDisposeAsyncNotifier<T> {
  /// Refresh the data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
