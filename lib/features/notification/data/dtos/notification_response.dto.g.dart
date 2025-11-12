// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponseDto _$NotificationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    NotificationResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: NotificationDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationResponseDtoToJson(
        NotificationResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

NotificationDataDto _$NotificationDataDtoFromJson(Map<String, dynamic> json) =>
    NotificationDataDto(
      mensagemId: json['mensagemId'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$NotificationDataDtoToJson(
        NotificationDataDto instance) =>
    <String, dynamic>{
      'mensagemId': instance.mensagemId,
      'status': instance.status,
    };
