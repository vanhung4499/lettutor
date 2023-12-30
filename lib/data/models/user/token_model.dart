import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenModel {
  @JsonKey(name: 'token')
  final String? token;

  @JsonKey(name: 'expires')
  final DateTime? expires;

  TokenModel(this.token, this.expires);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
}
