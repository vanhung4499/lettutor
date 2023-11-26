import 'package:dio/dio.dart';
import 'package:lettutor/data/models/response/topic_response.dart';
import 'package:retrofit/retrofit.dart';

part 'common_api.g.dart';

@RestApi()
abstract class CommonApi {

  factory CommonApi(Dio dio) = _CommonApi;

  @GET("/call/total")
  Future<int> getTotalTime();

  @GET("/learn-topic")
  Future<List<TopicResponse>?> getTopic();

  @GET("/test-preparation")
  Future<List<TopicResponse>?> getTestPreparation();
}
