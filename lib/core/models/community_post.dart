import 'app_user.dart';

enum PostStatus { draft, pendingReview, published, rejected }

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String title;
  final String body;
  final AppUser author;
  final DateTime createdAt;
  final PostStatus status;
}
