// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VersionState _$VersionStateFromJson(Map<String, dynamic> json) =>
    _VersionState(
      minVersion: json['minVersion'] as String? ?? '0.0.0',
      latestVersion: json['latestVersion'] as String? ?? '0.0.0',
      forceUpdate: json['forceUpdate'] as bool? ?? false,
    );

Map<String, dynamic> _$VersionStateToJson(_VersionState instance) =>
    <String, dynamic>{
      'minVersion': instance.minVersion,
      'latestVersion': instance.latestVersion,
      'forceUpdate': instance.forceUpdate,
    };
