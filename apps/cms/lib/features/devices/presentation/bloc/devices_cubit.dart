import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DevicesState {
  const DevicesState({this.loading = true, this.items = const [], this.failure, this.platform});
  final bool loading;
  final List<Device> items;
  final Failure? failure;
  final DevicePlatform? platform;
}

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit(this._get, this._revoke) : super(const DevicesState());
  final GetDevices _get;
  final RevokeDevice _revoke;

  Future<void> load([DevicePlatform? platform]) async {
    emit(DevicesState(items: state.items, platform: platform));
    final result = await _get(platform: platform);
    emit(switch (result) {
      Ok(:final value) => DevicesState(loading: false, items: value, platform: platform),
      Err(:final failure) => DevicesState(loading: false, failure: failure, platform: platform),
    });
  }

  Future<Result<void>> revoke(Device d) async {
    final result = await _revoke(d.id);
    if (result case Ok()) await load(state.platform);
    return result;
  }
}
