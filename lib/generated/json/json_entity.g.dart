import 'package:language_parse/generated/json/base/json_convert_content.dart';
import 'package:language_parse/model/json_entity.dart';

JsonEntity $JsonEntityFromJson(Map<String, dynamic> json) {
  final JsonEntity jsonEntity = JsonEntity();
  final String? key = jsonConvert.convert<String>(json['key']);
  if (key != null) {
    jsonEntity.key = key;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    jsonEntity.value = value;
  }
  return jsonEntity;
}

Map<String, dynamic> $JsonEntityToJson(JsonEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['key'] = entity.key;
  data['value'] = entity.value;
  return data;
}

extension JsonEntityExtension on JsonEntity {
  JsonEntity copyWith({
    String? key,
    String? value,
  }) {
    return JsonEntity()
      ..key = key ?? this.key
      ..value = value ?? this.value;
  }
}