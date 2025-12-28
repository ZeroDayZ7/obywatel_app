// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VersionState _$VersionStateFromJson(Map<String, dynamic> json) =>
    _VersionState(
      minVersion: json['minVersion'] as String,
      latestVersion: json['latestVersion'] as String,
      forceUpdate: json['forceUpdate'] as bool,
    );

Map<String, dynamic> _$VersionStateToJson(_VersionState instance) =>
    <String, dynamic>{
      'minVersion': instance.minVersion,
      'latestVersion': instance.latestVersion,
      'forceUpdate': instance.forceUpdate,
    };
