import 'package:dio/dio.dart';
import 'package:lettutor/data/models/response/list_schedule_response.dart';
import 'package:lettutor/data/models/response/list_tutor_response.dart';
import 'package:lettutor/data/models/response/review_response.dart';
import 'package:lettutor/data/models/response/search_tutor_response.dart';
import 'package:lettutor/data/models/tutor/tutor_detail_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'tutor_api.g.dart';

@RestApi()
abstract class TutorApi {
  factory TutorApi(Dio dio) = _TutorApi;

  @GET('/tutor/more?perPage={size}&page={page}')
  Future<HttpResponse<ListTutorResponse?>> pagFetchData(
      @Path('page') int page,
      @Path('size') int size,
      );

  @POST("/user/manageFavoriteTutor")
  Future<HttpResponse> addTutorToFavorite(
      {@Body() required Map<String, dynamic> body});

  @POST("/tutor/search")
  Future<HttpResponse<SearchTutorResponse?>> searchTutor(
      {@Body() required Map<String, dynamic> body});

  @GET('/tutor/{id}')
  Future<HttpResponse<TutorDetailModel?>> getTutorById(@Path('id') String id);

  @GET(
      '/schedule?tutorId={tutorId}&startTimestamp={sT}&endTimestamp={eT}')
  Future<HttpResponse<ListScheduleResponse?>> getTutorSchedule(
      @Path('tutorId') String tutorId, @Path('sT') int st, @Path('eT') int et);

  @GET('/feedback/v2/{id}')
  Future<HttpResponse<ListReviewResponse>> listReview(@Path('id') String id,
      {@Body() required Map<String, dynamic> body});
}
