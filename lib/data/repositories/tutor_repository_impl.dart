import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/data/models/response/list_tutor_response.dart';
import 'package:lettutor/data/providers/network/apis/tutor_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/schedule.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/domain/entities/tutor/tutor_detail.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';
import 'package:lettutor/domain/repositories/tutor_repository.dart';

@Injectable(as: TutorRepository)
class TutorRepositoryImpl extends BaseApi implements TutorRepository {
  final TutorApi _tutorApi;
  TutorRepositoryImpl(this._tutorApi);

  @override
  SingleResult<TutorFav> getListTutor(
      {required int page, required int perPage}) =>
      SingleResult.fromCallable(() async {
        await Future.delayed(const Duration(seconds: 2));
        final response = await getStateOf<ListTutorResponse?>(
          request: () async => await _tutorApi.pagFetchData(page, perPage),
        );
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final tutorResponse = response.data;

        if (tutorResponse == null) {
          return Either.left(AppException(message: 'Data error'));
        }

        return Either.right(TutorFav(
          tutors: Pagination<Tutor>(
            count: tutorResponse.count,
            currentPage: page,
            rows: tutorResponse.tutors.map((e) => e.toEntity()).toList(),
          ),
          fav: response.data?.favTutors ?? [],
        ));
      });

  @override
  SingleResult<bool> addTutorToFavorite({required String userId}) =>
      SingleResult.fromCallable(
            () async {
          final response = await getStateOf(
            request: () async =>
            await _tutorApi.addTutorToFavorite(body: {"tutorId": userId}),
          );
          if (response is DataFailed) {
            return Either.left(
              AppException(message: response.dioError?.message ?? 'Error'),
            );
          }
          return Either.right(true);
        },
      );

  @override
  SingleResult<TutorFav?> searchTutor(
      {required SearchTutorRequest searchTutorRequest}) =>
      SingleResult.fromCallable(() async {
        await Future.delayed(const Duration(seconds: 2));
        final body = {
          'page': searchTutorRequest.page,
          'perPage': searchTutorRequest.perPage,
          'search': searchTutorRequest.search,
          'filters': {
            'specialties': searchTutorRequest.topics,
            'nationality': searchTutorRequest.nationality,
          },
        };
        final response = await getStateOf(
            request: () async => await _tutorApi.searchTutor(body: body));
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final tutorResponse = response.data;
        if (tutorResponse == null) {
          return Either.left(
            AppException(message: 'Data null'),
          );
        }
        return Either.right(
          TutorFav(
            tutors: Pagination<Tutor>(
              count: tutorResponse.count,
              currentPage: searchTutorRequest.page,
              rows: tutorResponse.tutors.map((e) => e.toEntity()).toList(),
            ),
          ),
        );
      });

  @override
  SingleResult<TutorDetail?> getTutorById({required String userId}) =>
      SingleResult.fromCallable(() async {
        final response = await getStateOf(
            request: () async => _tutorApi.getTutorById(userId));
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final tutorDetail = response.data;
        if (tutorDetail == null) {
          return Either.left(
            AppException(message: 'Data null'),
          );
        }
        return Either.right(tutorDetail.toEntity());
      });

  @override
  SingleResult<List<Schedule>> getTutorSchedule(
      {required String tutorId,
        required DateTime startTime,
        required DateTime endTime}) =>
      SingleResult.fromCallable(() async {
        await Future.delayed(const Duration(seconds: 2));
        final response = await getStateOf(
          request: () async => await _tutorApi.getTutorSchedule(tutorId,
              startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch),
        );
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final listSchedule = response.data;
        if (listSchedule == null) {
          return Either.left(
            AppException(message: 'Data null'),
          );
        }
        listSchedule.schedules
            .sort((a, b) => a.startTimestamp > b.startTimestamp ? 1 : 0);
        return Either.right(
          listSchedule.schedules
              .where((e) => !e.isBooked)
              .map((e) => e.toEntity())
              .toList(),
        );
      });

  @override
  SingleResult<Pagination<Review>> getListReview(
      {required int page, required int perPage, required String userId}) =>
      SingleResult.fromCallable(() async {
        final body = {"page": page, "perPage": perPage};
        final response = await getStateOf(
            request: () async => _tutorApi.listReview(userId, body: body));
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final data = response.data;
        if (data == null) {
          return Either.left(
            AppException(message: "Data null"),
          );
        }
        return Either.right(
          Pagination<Review>(
            rows: data.reviews.map((e) => e.toEntity()).toList(),
            count: data.count,
            currentPage: page,
            perPage: perPage,
          ),
        );
      });
}
