// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failures.dart';
// import '../repositories/feed_repository.dart';

// class EditCommentUseCase {
//   final FeedRepository repository;

//   EditCommentUseCase(this.repository);

//   Future<Either<Failure, void>> call({
//     required String commentId,
//     required String content,
//     bool isReply = false,
//     List<String>? taggedUsers,
//   }) async {
//     return await repository.editComment(
//       commentId: commentId,
//       content: content,
//       isReply: isReply,
//       taggedUsers: taggedUsers ?? [],
//     );
//   }
// }
