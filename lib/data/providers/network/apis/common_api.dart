import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/response/ebook_response.dart';
import 'package:lettutor/data/models/response/topic_response.dart';
import 'package:retrofit/retrofit.dart';

part 'common_api.g.dart';

@injectable
@RestApi()
abstract class CommonApi {

  @factoryMethod
  factory CommonApi(Dio dio) = _CommonApi;

  @GET("/call/total")
  Future<HttpResponse<int>> getTotalTime();

  @GET("/learn-topic")
  Future<HttpResponse<List<TopicResponse>?>> getTopic();

  @GET("/test-preparation")
  Future<HttpResponse<List<TopicResponse>?>> getTestPreparation();

  @GET("/e-book")
  Future<HttpResponse<EbookResponse?>> getListEbook(
      @Queries() Map<String, dynamic> queries);
}
