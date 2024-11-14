import 'package:language_parse/generated/json/base/json_field.dart';
import 'package:language_parse/generated/json/json_entity.g.dart';
import 'dart:convert';
export 'package:language_parse/generated/json/json_entity.g.dart';

@JsonSerializable()
class JsonEntity {
	late String key = '';
	late String value = '';

	JsonEntity();

	factory JsonEntity.fromJson(Map<String, dynamic> json) => $JsonEntityFromJson(json);

	Map<String, dynamic> toJson() => $JsonEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}