


import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/core/data/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/response/list_course_response.dart';
import 'package:lettutor/data/providers/network/apis/course_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';
import 'package:lettutor/domain/repositories/course_repository.dart';

class CourseRepositoryImpl extends BaseApi implements CourseRepository {
  final CourseApi _courseApi = Get.find();

  @override
  SingleResult<Pagination<Course>> getListCourse(
      {required int page,
        required int perPage,
        String? q,
        String? categoryId}) =>
      SingleResult.fromCallable(
            () async {
          await Future.delayed(const Duration(seconds: 2));
          final queries = <String, dynamic>{"page": page, "size": perPage};
          if (q?.isNotEmpty ?? false) {
            queries.addAll({"q": q!});
          }
          if (categoryId?.isNotEmpty ?? false) {
            queries.addAll({"categoryId": categoryId!});
          }
          final response = await getStateOf<ListCourseResponse?>(
            request: () async => await _courseApi.listCourses(queries),
          );
          if (response is DataFailed) {
            return Either.left(
              AppException(message: response.dioError?.message ?? 'Error'),
            );
          }
          final courseResponse = response.data;

          if (courseResponse == null) {
            return Either.left(AppException(message: 'Data error'));
          }

          if (courseResponse.status == 'Error') {
            return Either.left(AppException(message: 'Error'));
          }
          return Either.right(
            Pagination(
              count: courseResponse.count,
              currentPage: page,
              rows: courseResponse.courses.map((e) => e.toEntity()).toList(),
            ),
          );
        },
      );

  @override
  SingleResult<Course> getCourseDetail({required String courseId}) =>
      SingleResult.fromCallable(
            () async {
          await Future.delayed(const Duration(seconds: 1));
          final response = await getStateOf(
            request: () async => _courseApi.getCourse(courseId),
          );
          if (response is DataFailed) {
            return Either.left(
              AppException(message: response.dioError?.message ?? 'Error'),
            );
          }
          final courseResponse = response.data;
          if (courseResponse == null) {
            return Either.left(AppException(message: "Data null"));
          }
          if (courseResponse.message == 'Failed') {
            return Either.left(AppException(message: 'Error'));
          }
          return Either.right(
            courseResponse.data!.toEntity(),
          );
        },
      );

  @override
  SingleResult<List<CourseCategory>> getCourseCategory() =>
      SingleResult.fromCallable(() async {
        final response = await getStateOf(
          request: () async => await _courseApi.getContentCategory(),
        );
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final dataResponse = response.data;
        if (dataResponse?.rows.isNotEmpty ?? false) {
          return Either.right(
            dataResponse!.rows.map((e) => e.toEntity()).toList(),
          );
        }
        return Either.left(AppException(message: "Data null"));
      });
}
