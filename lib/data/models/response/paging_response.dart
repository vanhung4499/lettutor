import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging_response.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class PagingResponse<T> {
  @JsonKey(name: "currentPage")
  final int currentPage;
  @JsonKey(name: "pageSize")
  final int pageSize;
  @JsonKey(name: "totalPages")
  final int totalPages;
  @JsonKey(name: "responseData")
  final List<T> responseData;

  PagingResponse({
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.responseData,
  });
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PagingResponseToJson(this, toJsonT);

  factory PagingResponse.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromT) {
    return _$PagingResponseFromJson(json, fromT);
  }
}
