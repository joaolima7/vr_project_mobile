import 'package:json_annotation/json_annotation.dart';

part 'notification_response.dto.g.dart';

@JsonSerializable()
class NotificationResponseDto {
  final bool success;
  final String message;
  final NotificationDataDto data;

  const NotificationResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponseDto.fromJson(Map<String, dynamic> json) => _$NotificationResponseDtoFromJson(json);
}

@JsonSerializable()
class NotificationDataDto {
  final String mensagemId;
  final String status;

  const NotificationDataDto({
    required this.mensagemId,
    required this.status,
  });

  factory NotificationDataDto.fromJson(Map<String, dynamic> json) => _$NotificationDataDtoFromJson(json);
}
