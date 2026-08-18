import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/mock_repository.dart';
import '../../core/models/app_user.dart';
import '../../core/models/community_post.dart';
import '../../core/models/user_role.dart';
import '../../shared/widgets/section_header.dart';

class CommunityBoardScreen extends StatefulWidget {
  const CommunityBoardScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  State<CommunityBoardScreen> createState() => _CommunityBoardScreenState();
}

class _CommunityBoardScreenState extends State<CommunityBoardScreen> {
  Future<void> _openEditor([CommunityPost? post]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _PostEditorScreen(
          currentUser: widget.currentUser,
          initialPost: post,
        ),
      ),
    );
    if (saved == true && mounted) setState(() {});
  }

  Future<void> _openPendingBoard() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _PendingPostsScreen(currentUser: widget.currentUser),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posts = MockRepository.posts(widget.currentUser);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Community board',
          subtitle: widget.currentUser.role.canPublishWithoutApproval
              ? 'Published community updates'
              : 'Your posts are reviewed before publication',
          trailing: FilledButton.icon(
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add),
            label: const Text('Post'),
          ),
        ),
        if (widget.currentUser.role.canReviewPosts) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _openPendingBoard,
            icon: const Icon(Icons.rate_review_outlined),
            label: Text(
              'Pending review (${MockRepository.pendingCommunityPosts().length})',
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (posts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: Text('No published posts.')),
          ),
        for (final post in posts) ...[
          _PostCard(
            post: post,
            onEdit: _canEdit(post) ? () => _openEditor(post) : null,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  bool _canEdit(CommunityPost post) {
    if (widget.currentUser.role == UserRole.level1Admin) return true;
    return post.status == PostStatus.published &&
        post.author.id == widget.currentUser.id &&
        const {
          UserRole.level2SemesterAdmin,
          UserRole.level3Teacher,
          UserRole.level4Student,
        }.contains(widget.currentUser.role);
  }
}

class _PostEditorScreen extends StatefulWidget {
  const _PostEditorScreen({
    required this.currentUser,
    this.initialPost,
  });

  final AppUser currentUser;
  final CommunityPost? initialPost;

  @override
  State<_PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<_PostEditorScreen> {
  static const _videoExtensions = [
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
    '.mpeg',
    '.mpg',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _headerController;
  late final TextEditingController _bodyController;
  late final TextEditingController _linkController;
  final _headerFocus = FocusNode();
  final _bodyFocus = FocusNode();
  final _linkFocus = FocusNode();
  String _attachmentPath = '';
  String _attachmentName = '';

  @override
  void initState() {
    super.initState();
    final post = widget.initialPost;
    _headerController = TextEditingController(text: post?.title ?? '');
    _bodyController = TextEditingController(text: post?.body ?? '');
    _linkController = TextEditingController(text: post?.linkUrl ?? '');
    _attachmentPath = post?.attachmentPath ?? '';
    _attachmentName = post?.attachmentName ?? '';
  }

  @override
  void dispose() {
    _headerController.dispose();
    _bodyController.dispose();
    _linkController.dispose();
    _headerFocus.dispose();
    _bodyFocus.dispose();
    _linkFocus.dispose();
    super.dispose();
  }

  Future<void> _addAttachment() async {
    final controller = TextEditingController(text: _attachmentPath);
    final path = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add file'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'File path or image URL',
            hintText: r'C:\Documents\announcement.pdf',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (path == null || path.isEmpty || !mounted) return;
    final normalized = path.toLowerCase().split('?').first;
    if (_videoExtensions.any(normalized.endsWith)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video attachments are not supported.')),
      );
      return;
    }
    setState(() {
      _attachmentPath = path;
      _attachmentName = path.split(RegExp(r'[\/]')).last;
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final initialPost = widget.initialPost;
    if (initialPost == null) {
      MockRepository.submitCommunityPost(
        author: widget.currentUser,
        title: _headerController.text,
        body: _bodyController.text,
        linkUrl: _linkController.text,
        attachmentPath: _attachmentPath,
        attachmentName: _attachmentName,
      );
    } else {
      MockRepository.updateCommunityPost(
        postId: initialPost.id,
        editor: widget.currentUser,
        title: _headerController.text,
        body: _bodyController.text,
        linkUrl: _linkController.text,
        attachmentPath: _attachmentPath,
        attachmentName: _attachmentName,
      );
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final publishesNow = widget.currentUser.role.canPublishWithoutApproval;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.initialPost == null ? 'Post editor' : 'Edit post'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 4,
              children: [
                IconButton(
                  tooltip: 'Header',
                  onPressed: _headerFocus.requestFocus,
                  icon: const Icon(Icons.title),
                ),
                IconButton(
                  tooltip: 'Body',
                  onPressed: _bodyFocus.requestFocus,
                  icon: const Icon(Icons.notes),
                ),
                IconButton(
                  tooltip: 'Link',
                  onPressed: _linkFocus.requestFocus,
                  icon: const Icon(Icons.link),
                ),
                IconButton(
                  tooltip: 'Attach file',
                  onPressed: _addAttachment,
                  icon: const Icon(Icons.attach_file),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _headerController,
              focusNode: _headerFocus,
              decoration: const InputDecoration(labelText: 'Header'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              focusNode: _bodyFocus,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(labelText: 'Body'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _linkController,
              focusNode: _linkFocus,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Link (optional)',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            if (_attachmentPath.isNotEmpty) ...[
              const SizedBox(height: 12),
              ListTile(
                leading: Icon(
                  _isSupportedImage(_attachmentPath)
                      ? Icons.image_outlined
                      : Icons.insert_drive_file_outlined,
                ),
                title: Text(_attachmentName),
                subtitle: Text(
                  _attachmentPath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  tooltip: 'Remove attachment',
                  onPressed: () => setState(() {
                    _attachmentPath = '';
                    _attachmentName = '';
                  }),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(
                publishesNow ? Icons.publish_outlined : Icons.send_outlined,
              ),
              label: Text(
                widget.initialPost == null
                    ? publishesNow
                        ? 'Publish post'
                        : 'Submit for approval'
                    : publishesNow
                        ? 'Save changes'
                        : 'Submit changes for approval',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingPostsScreen extends StatefulWidget {
  const _PendingPostsScreen({required this.currentUser});

  final AppUser currentUser;

  @override
  State<_PendingPostsScreen> createState() => _PendingPostsScreenState();
}

class _PendingPostsScreenState extends State<_PendingPostsScreen> {
  Future<void> _edit(CommunityPost post) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _PostEditorScreen(
          currentUser: widget.currentUser,
          initialPost: post,
        ),
      ),
    );
    if (saved == true && mounted) setState(() {});
  }

  void _approve(CommunityPost post) {
    MockRepository.approveCommunityPost(post.id);
    setState(() {});
  }

  void _reject(CommunityPost post) {
    MockRepository.rejectCommunityPost(post.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posts = MockRepository.pendingCommunityPosts();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Pending community posts'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (posts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(child: Text('No posts awaiting review.')),
            ),
          for (final post in posts) ...[
            _PostCard(
              post: post,
              onEdit: () => _edit(post),
              moderationActions: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Reject',
                    onPressed: () => _reject(post),
                    icon: const Icon(Icons.close),
                  ),
                  IconButton(
                    tooltip: 'Approve',
                    onPressed: () => _approve(post),
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    this.onEdit,
    this.moderationActions,
  });

  final CommunityPost post;
  final VoidCallback? onEdit;
  final Widget? moderationActions;

  @override
  Widget build(BuildContext context) {
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
                if (onEdit != null)
                  IconButton(
                    tooltip: 'Edit post',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                if (moderationActions != null) moderationActions!,
              ],
            ),
            const SizedBox(height: 8),
            Text(post.body),
            if (post.linkUrl.isNotEmpty) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _copyLink(context, post.linkUrl),
                icon: const Icon(Icons.link),
                label: Text(
                  post.linkUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (post.hasAttachment) ...[
              const SizedBox(height: 12),
              if (post.attachmentIsImage)
                _PostImage(path: post.attachmentPath)
              else
                OutlinedButton.icon(
                  onPressed: () => _downloadAttachment(context, post),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(
                    post.attachmentName.isEmpty
                        ? 'Download file'
                        : post.attachmentName,
                  ),
                ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                    child: Text(post.author.displayName.substring(0, 1))),
                const SizedBox(width: 8),
                Expanded(child: Text(post.author.displayName)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final image = _imageForPath(path);
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        barrierColor: Colors.black,
        builder: (context) => Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Center(child: _imageForPath(path)),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton.filled(
                  tooltip: 'Close image',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250, maxHeight: 250),
        child: image,
      ),
    );
  }
}

Widget _imageForPath(String path) {
  Widget error(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) =>
      const SizedBox(
        width: 250,
        height: 120,
        child: Center(child: Text('Image unavailable')),
      );
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return Image.network(path, fit: BoxFit.contain, errorBuilder: error);
  }
  return Image.file(File(path), fit: BoxFit.contain, errorBuilder: error);
}

bool _isSupportedImage(String path) {
  final normalized = path.toLowerCase().split('?').first;
  return const ['.gif', '.jpeg', '.jpg', '.png'].any(normalized.endsWith);
}

Future<void> _copyLink(BuildContext context, String link) async {
  await Clipboard.setData(ClipboardData(text: link));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Link copied.')),
  );
}

Future<void> _downloadAttachment(
  BuildContext context,
  CommunityPost post,
) async {
  final path = post.attachmentPath;
  if (path.startsWith('http://') || path.startsWith('https://')) {
    await Clipboard.setData(ClipboardData(text: path));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download link copied.')),
    );
    return;
  }
  final source = File(path);
  if (!await source.exists()) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('The attached file is no longer available.')),
    );
    return;
  }
  final home = Platform.environment['USERPROFILE'];
  final directory = Platform.isWindows && home != null
      ? Directory('$home${Platform.pathSeparator}Downloads')
      : Directory.systemTemp;
  final name = post.attachmentName.isEmpty
      ? source.uri.pathSegments.last
      : post.attachmentName;
  final destination = File(
    '${directory.path}${Platform.pathSeparator}$name',
  );
  await source.copy(destination.path);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Saved to ${destination.path}')),
  );
}
