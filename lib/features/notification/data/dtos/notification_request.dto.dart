import 'package:json_annotation/json_annotation.dart';

part 'notification_request.dto.g.dart';

@JsonSerializable()
class NotificationRequestDto {
  final String conteudoMensagem;

  const NotificationRequestDto({
    required this.conteudoMensagem,
  });

  Map<String, dynamic> toJson() => _$NotificationRequestDtoToJson(this);
}
