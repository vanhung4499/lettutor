import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/user/wallet_info.dart';

part 'wallet_info_model.g.dart';

@JsonSerializable()
class WalletInfoModel {
  @JsonKey(name: 'amount')
  final String? amount;

  @JsonKey(name: 'isBlocked')
  final bool? isBlocked;

  @JsonKey(name: 'bonus')
  final int? bonus;

  WalletInfoModel(this.amount, this.isBlocked, this.bonus);

  factory WalletInfoModel.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletInfoModelToJson(this);

  WalletInfo toEntity() => WalletInfo(
      amount: amount ?? '0', isBlocked: isBlocked ?? false, bonus: bonus ?? 0);
}
