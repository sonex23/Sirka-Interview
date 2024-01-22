part of 'chat_cubit.dart';

@freezed
class ChatCubitState with _$ChatCubitState {
  const factory ChatCubitState.loading() = _Loading;
  const factory ChatCubitState.loaded(List data) = _Loaded;
  const factory ChatCubitState.error(String error) = _Error;
}

extension ChatCubitStateExtension on ChatCubitState {
  bool get isLoading => this is _Loading;
  bool get isError => this is _Error;
  bool get isLoaded => this is _Loaded;
  String? get errorMessage => mapOrNull(error: (value) => value.error);
  List? get listChat => mapOrNull(loaded: (value) => value.data);
}
