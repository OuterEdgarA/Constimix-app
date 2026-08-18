import 'package:constimix_app/core/data/mock_repository.dart';
import 'package:constimix_app/core/models/community_post.dart';
import 'package:constimix_app/features/community/community_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('non-L1 posts wait for approval and L1 can publish them', () {
    final author = MockRepository.users[1];
    final post = MockRepository.submitCommunityPost(
      author: author,
      title: 'Approval workflow test',
      body: 'This should remain isolated until an L1 approves it.',
      createdAt: DateTime(2026, 7, 15),
    );

    expect(post.status, PostStatus.pendingReview);
    expect(
      MockRepository.posts(author).any((item) => item.id == post.id),
      isFalse,
    );
    expect(
      MockRepository.pendingCommunityPosts().any((item) => item.id == post.id),
      isTrue,
    );

    MockRepository.approveCommunityPost(post.id);
    expect(
      MockRepository.posts(author).any((item) => item.id == post.id),
      isTrue,
    );
  });

  test('posts associated with a cycle are purged after that cycle ends', () {
    final admin = MockRepository.users.first;
    final post = MockRepository.submitCommunityPost(
      author: admin,
      title: 'Expired cycle post',
      body: 'This post belongs to a completed cycle.',
      createdAt: DateTime(2026, 12, 30),
    );
    expect(
        MockRepository.posts(admin).any((item) => item.id == post.id), isTrue);

    MockRepository.purgeCommunityPosts(DateTime(2027, 1, 1));
    expect(
      MockRepository.posts(admin).any((item) => item.id == post.id),
      isFalse,
    );
  });

  test('approved author edits return to review while L1 edits stay published',
      () {
    final author = MockRepository.users[1];
    final admin = MockRepository.users.first;
    final post = MockRepository.submitCommunityPost(
      author: author,
      title: 'Original approved post',
      body: 'Original body',
      createdAt: DateTime(2026, 7, 16),
    );
    MockRepository.approveCommunityPost(post.id);

    final authorEdit = MockRepository.updateCommunityPost(
      postId: post.id,
      editor: author,
      title: 'Author edit',
      body: 'Changed by the author',
    );
    expect(authorEdit?.status, PostStatus.pendingReview);
    expect(
      MockRepository.posts(author).any((item) => item.id == post.id),
      isFalse,
    );

    MockRepository.approveCommunityPost(post.id);
    final adminEdit = MockRepository.updateCommunityPost(
      postId: post.id,
      editor: admin,
      title: 'Admin edit',
      body: 'Changed by L1',
    );
    expect(adminEdit?.status, PostStatus.published);
    expect(adminEdit?.title, 'Admin edit');
  });

  testWidgets('board editor submits a staff post to the hidden review board',
      (tester) async {
    final author = MockRepository.users[1];
    await tester.pumpWidget(
      MaterialApp(home: CommunityBoardScreen(currentUser: author)),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Post'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Header'),
      'Widget approval post',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Body'),
      'A post created from the board editor.',
    );
    await tester.tap(
      find.widgetWithText(FilledButton, 'Submit for approval'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Widget approval post'), findsNothing);
    expect(
      MockRepository.pendingCommunityPosts()
          .any((item) => item.title == 'Widget approval post'),
      isTrue,
    );
  });

  testWidgets('approved authors can edit and resubmit their posts',
      (tester) async {
    final author = MockRepository.users[1];
    final post = MockRepository.submitCommunityPost(
      author: author,
      title: 'Editable approved post',
      body: 'Approved content',
      createdAt: DateTime(2026, 7, 17),
    );
    MockRepository.approveCommunityPost(post.id);
    await tester.pumpWidget(
      MaterialApp(home: CommunityBoardScreen(currentUser: author)),
    );

    await tester.tap(find.byTooltip('Edit post').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Header'),
      'Edited approved post',
    );
    await tester.tap(
      find.widgetWithText(FilledButton, 'Submit changes for approval'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edited approved post'), findsNothing);
    expect(
      MockRepository.pendingCommunityPosts().any(
        (item) => item.id == post.id && item.title == 'Edited approved post',
      ),
      isTrue,
    );
  });
}
