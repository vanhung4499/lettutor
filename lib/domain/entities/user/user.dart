import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/domain/entities/user/wallet_info.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? email,
    String? phone,
    String? avatar,
    String? level,
    String? country,
    String? language,
    String? requireNote,
    String? studySchedule,
    String? creditCardNumber,
    DateTime? birthday,
    Tutor? tutorInfo,
    int? timezone,
    double? avgRating,
    WalletInfo? walletInfo,
    List<String>? roles,
    @Default(true) bool isActivated,
    @Default(<Topic>[]) List<Topic> learnTopics,
    @Default(<Topic>[]) List<Topic> testPreparations,
    @Default(true) bool isPhoneActivated,
    @Default(false) bool canSendMessage,
  }) = _User;
}
