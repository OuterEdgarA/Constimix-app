import 'package:flutter/material.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/community_post.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';

class CommunityBoardScreen extends StatelessWidget {
  const CommunityBoardScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final posts = MockRepository.posts(currentUser);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Community board',
          subtitle: currentUser.role.canPublishWithoutApproval
              ? 'Posts publish immediately for level 1 users.'
              : 'New posts are submitted for level 1 approval.',
          trailing: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Post'),
          ),
        ),
        if (currentUser.role.canReviewPosts) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Review pending posts'),
          ),
        ],
        const SizedBox(height: 16),
        for (final post in posts) ...[
          _PostCard(post: post, role: currentUser.role),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.role});

  final CommunityPost post;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (post.status == PostStatus.pendingReview)
                  Chip(
                    label: const Text('Pending'),
                    backgroundColor: scheme.secondaryContainer,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.body),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.author.displayName.substring(0, 1)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(post.author.displayName)),
                if (role.canReviewPosts && post.status == PostStatus.pendingReview)
                  IconButton(
                    tooltip: 'Approve',
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle_outline),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

