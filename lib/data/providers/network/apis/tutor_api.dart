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
  static const String addTutorFavoriteApi = "/user/manageFavoriteTutor";
  static const String searchTutorApi = "/tutor/search";
  static const String getTutorByIdApi = "/tutor";
  static const String fetchTutorScheduleApi = "/schedule";

  factory TutorApi(Dio dio) = _TutorApi;

  @GET('/tutor/more?perPage={size}&page={page}')
  Future<ListTutorResponse?> pagFetchData(
      @Path('page') int page,
      @Path('size') int size,
      );

  @POST("/user/manageFavoriteTutor")
  Future<void> addTutorToFavorite(
      {@Body() required Map<String, dynamic> body});

  @POST("/tutor/search")
  Future<SearchTutorResponse?> searchTutor(
      {@Body() required Map<String, dynamic> body});

  @GET('/tutor/{id}')
  Future<TutorDetailModel?> getTutorById(@Path('id') String id);

  @GET(
      '/schedule?tutorId={tutorId}&startTimestamp={sT}&endTimestamp={eT}')
  Future<ListScheduleResponse?> fetchTutorSchedule(
      @Path('tutorId') String tutorId, @Path('sT') int st, @Path('eT') int et);

  @GET('/feedback/v2/{id}')
  Future<ListReviewResponse> getReviews(@Path('id') String id,
      {@Body() required Map<String, dynamic> body});
}
