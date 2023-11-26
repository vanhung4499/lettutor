import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/data/models/user/token_model.dart';

part 'user_token_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserTokenModel {
  @JsonKey(name: 'access')
  final TokenModel? access;

  @JsonKey(name: 'refresh')
  final TokenModel? refresh;

  UserTokenModel(this.access, this.refresh);

  Map<String, dynamic> toJson() => _$UserTokenModelToJson(this);

  factory UserTokenModel.fromJson(Map<String, dynamic> json) =>
      _$UserTokenModelFromJson(json);
}
