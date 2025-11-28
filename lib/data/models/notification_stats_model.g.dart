// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationStatsModel _$NotificationStatsModelFromJson(
  Map<String, dynamic> json,
) => NotificationStatsModel(
  totalCount: (json['totalCount'] as num).toInt(),
  unreadCount: (json['unreadCount'] as num).toInt(),
  readCount: (json['readCount'] as num).toInt(),
  countByType: Map<String, int>.from(json['countByType'] as Map),
);

Map<String, dynamic> _$NotificationStatsModelToJson(
  NotificationStatsModel instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'unreadCount': instance.unreadCount,
  'readCount': instance.readCount,
  'countByType': instance.countByType,
};
