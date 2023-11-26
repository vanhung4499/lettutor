import 'package:dio/dio.dart';
import 'package:lettutor/data/models/response/content_category_response.dart';
import 'package:lettutor/data/models/response/course_detail_response.dart';
import 'package:lettutor/data/models/response/list_course_response.dart';
import 'package:retrofit/retrofit.dart';

part 'course_api.g.dart';

@RestApi()
abstract class CourseApi {
  factory CourseApi(Dio dio) = _CourseApi;

  @GET("/course")
  Future<ListCourseResponse?> listCourses(
      Map<String, dynamic> queries,
      );

  @GET("/course/{id}")
  Future<CourseDetailResponse?> getCourse(
      @Path("id") String courseId,
      );

  @POST("/content-category")
  Future<ContentCategoryResponse?> createCourse();
}