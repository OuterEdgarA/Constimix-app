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
    this.linkUrl = '',
    this.attachmentPath = '',
    this.attachmentName = '',
    this.cycleId,
  });

  final String id;
  final String title;
  final String body;
  final AppUser author;
  final DateTime createdAt;
  final PostStatus status;
  final String linkUrl;
  final String attachmentPath;
  final String attachmentName;
  final String? cycleId;

  bool get hasAttachment => attachmentPath.trim().isNotEmpty;

  bool get attachmentIsImage {
    final path = attachmentPath.toLowerCase().split('?').first;
    return const ['.gif', '.jpeg', '.jpg', '.png'].any(path.endsWith);
  }

  CommunityPost copyWith({
    String? title,
    String? body,
    PostStatus? status,
    String? linkUrl,
    String? attachmentPath,
    String? attachmentName,
    String? cycleId,
  }) {
    return CommunityPost(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      author: author,
      createdAt: createdAt,
      status: status ?? this.status,
      linkUrl: linkUrl ?? this.linkUrl,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      attachmentName: attachmentName ?? this.attachmentName,
      cycleId: cycleId ?? this.cycleId,
    );
  }
}
