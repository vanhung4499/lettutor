// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTokenModel _$UserTokenModelFromJson(Map<String, dynamic> json) =>
    UserTokenModel(
      json['access'] == null
          ? null
          : TokenModel.fromJson(json['access'] as Map<String, dynamic>),
      json['refresh'] == null
          ? null
          : TokenModel.fromJson(json['refresh'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserTokenModelToJson(UserTokenModel instance) =>
    <String, dynamic>{
      'access': instance.access?.toJson(),
      'refresh': instance.refresh?.toJson(),
    };
