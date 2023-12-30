import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/response/content_category_response.dart';
import 'package:lettutor/data/models/response/course_detail_response.dart';
import 'package:lettutor/data/models/response/list_course_response.dart';
import 'package:retrofit/retrofit.dart';

part 'course_api.g.dart';

@injectable
@RestApi()
abstract class CourseApi {

  @factoryMethod
  factory CourseApi(Dio dio) = _CourseApi;

  @GET("/course")
  Future<HttpResponse<ListCourseResponse?>> listCourses(
      Map<String, dynamic> queries,
      );

  @GET("/course/{id}")
  Future<HttpResponse<CourseDetailResponse?>> getCourse(
      @Path("id") String courseId,
      );

  @GET("/content-category")
  Future<HttpResponse<ContentCategoryResponse?>> getContentCategory();
}