import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedFilter = 'Recent';
  String _selectedPostType = 'Discussion';
  String _selectedSubject = 'Mathematics';
  bool _showCreatePost = false;
  String? _editingPostId;

  final List<String> _categories = ['All', 'Assignment Help', 'Study Groups', 'Questions', 'Resources', 'Announcements'];
  final List<String> _postTypes = ['Discussion', 'Question', 'Assignment Help', 'Resource Share'];
  final List<String> _filters = ['Recent', 'Popular', 'My Posts'];
  final List<String> _subjects = ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'Astronomy', 'Computer Science'];

  @override
  void initState() {
    super.initState();
    // Initialize data
  }

  Future<void> _createPost() async {
    final user = _auth.currentUser;
    if (user == null || _postController.text.trim().isEmpty) return;

    final postData = {
      'userId': user.uid,
      'userName': user.displayName ?? 'Anonymous',
      'userEmail': user.email,
      'title': _postController.text.split('\n').first,
      'content': _postController.text,
      'type': _selectedPostType,
      'category': _selectedPostType == 'Assignment Help' ? 'Assignment Help' :
      _selectedPostType == 'Question' ? 'Questions' : 'Discussion',
      'subject': _selectedPostType == 'Assignment Help' ? _selectedSubject : null,
      'tags': _extractTags(_postController.text),
      'timestamp': FieldValue.serverTimestamp(),
      'likes': [],
      'comments': [],
      'views': 0,
      'isResolved': false,
      'isEdited': false,
      'commentCount': 0,
    };

    try {
      await _firestore.collection('posts').add(postData);
      _postController.clear();
      setState(() => _showCreatePost = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Post published successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error saving post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editPost(String postId, String currentContent) async {
    final user = _auth.currentUser;
    if (user == null || _editController.text.trim().isEmpty) return;

    try {
      await _firestore.collection('posts').doc(postId).update({
        'content': _editController.text,
        'isEdited': true,
      });

      _editController.clear();
      setState(() => _editingPostId = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📝 Post updated successfully!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error updating post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletePost(String postId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestore.collection('posts').doc(postId).delete();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🗑️ Post deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ Error deleting post: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleLike(String postId, List<dynamic> currentLikes) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      if (currentLikes.contains(user.uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([user.uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([user.uid])
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error updating like: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addComment(String postId, String comment) async {
    final user = _auth.currentUser;
    if (user == null || comment.trim().isEmpty) return;

    try {
      final commentData = {
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'content': comment,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.arrayUnion([commentData]),
        'commentCount': FieldValue.increment(1),
      });

      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error adding comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<String> _extractTags(String content) {
    final words = content.split(' ');
    final tags = <String>[];
    for (final word in words) {
      if (word.startsWith('#') && word.length > 1) {
        tags.add(word.substring(1));
      }
    }
    return tags;
  }

  String _formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Recently';

    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  Widget _buildCreatePostCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create a Post',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _showCreatePost = false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Post Type Selection
            const Text('Post Type', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _postTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _selectedPostType == type,
                  onSelected: (selected) => setState(() => _selectedPostType = type),
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.pink[100],
                  labelStyle: TextStyle(
                    color: _selectedPostType == type ? Colors.pink : Colors.black,
                  ),
                );
              }).toList(),
            ),

            // Subject Selection for Assignment Help ONLY
            if (_selectedPostType == 'Assignment Help') ...[
              const SizedBox(height: 16),
              const Text('Subject', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                items: _subjects.map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSubject = value);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select subject',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                isExpanded: true,
              ),
            ],

            const SizedBox(height: 16),
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: _selectedPostType == 'Assignment Help'
                    ? 'Describe your assignment problem...\nUse #tags for better visibility'
                    : _selectedPostType == 'Question'
                    ? 'Ask your question here...'
                    : 'Share your thoughts...',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              maxLines: 5,
              maxLength: 1000,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _showCreatePost = false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _createPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Publish Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Assignment Help': return Colors.orange;
      case 'Questions': return Colors.blue;
      case 'Study Groups': return Colors.green;
      case 'Resources': return Colors.purple;
      case 'Announcements': return Colors.red;
      default: return Colors.grey;
    }
  }

  Stream<QuerySnapshot> _getFilteredPostsStream() {
    try {
      Query query = _firestore.collection('posts').orderBy('timestamp', descending: true);

      if (_selectedCategory != 'All') {
        query = query.where('category', isEqualTo: _selectedCategory);
      }

      if (_selectedFilter == 'My Posts' && _auth.currentUser != null) {
        query = query.where('userId', isEqualTo: _auth.currentUser!.uid);
      }

      return query.snapshots();
    } catch (e) {
      // Return empty stream if error
      return const Stream.empty();
    }
  }

  Widget _buildPostCard(Map<String, dynamic> data, String postId) {
    final likes = List<dynamic>.from(data['likes'] ?? []);
    final comments = List<Map<String, dynamic>>.from(data['comments'] ?? []);
    final currentUserId = _auth.currentUser?.uid;
    final isAuthor = currentUserId == data['userId'];
    final commentCount = data['commentCount'] ?? comments.length;
    final userName = data['userName']?.toString() ?? 'Anonymous';
    final postContent = data['content']?.toString() ?? '';
    final postTitle = data['title']?.toString() ?? postContent.split('\n').first;
    final postType = data['type']?.toString() ?? 'Discussion';
    final postCategory = data['category']?.toString();
    final timestamp = data['timestamp'] as Timestamp?;
    final tags = List<dynamic>.from(data['tags'] ?? []);

    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink[100],
                  child: const Icon(Icons.person, color: Colors.pink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            _formatTimeAgo(timestamp),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          if (postCategory != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(postCategory).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                postType,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getCategoryColor(postCategory),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isAuthor)
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            const Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editController.text = postContent;
                        setState(() => _editingPostId = postId);
                      } else if (value == 'delete') {
                        _deletePost(postId);
                      }
                    },
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Post Title
            Text(
              postTitle,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Show subject for assignment help posts
            if (data['subject'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.class_, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Subject: ${data['subject']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],

            // Post Content
            if (_editingPostId != postId) ...[
              const SizedBox(height: 8),
              Text(
                postContent,
                style: const TextStyle(fontSize: 14),
              ),
            ] else ...[
              // Edit Mode
              const SizedBox(height: 12),
              TextField(
                controller: _editController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Edit your post...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _editingPostId = null),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _editPost(postId, postContent),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],

            // Tags
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: tags.map<Widget>((tag) {
                  return Chip(
                    label: Text('#${tag.toString()}'),
                    backgroundColor: Colors.grey[100],
                    labelStyle: const TextStyle(fontSize: 12),
                  );
                }).toList(),
              ),
            ],

            // Stats and Actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like Button
                GestureDetector(
                  onTap: () => _toggleLike(postId, likes),
                  child: Row(
                    children: [
                      Icon(
                        likes.contains(currentUserId) ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: likes.contains(currentUserId) ? Colors.pink : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        likes.length.toString(),
                        style: TextStyle(
                          color: likes.contains(currentUserId) ? Colors.pink : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Comment Button
                Row(
                  children: [
                    const Icon(Icons.comment, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      commentCount.toString(),
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),

            // Add Comment
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _addComment(postId, _commentController.text),
                  icon: const Icon(Icons.send, color: Colors.pink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        title: Text('NeuroTick Community', style: GoogleFonts.poppins()),
        backgroundColor: Colors.pink,
        actions: [
          if (_auth.currentUser != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => _showCreatePost = true),
            ),
        ],
      ),
      body: Column(
        children: [
          // Create Post Button (always visible for logged-in users)
          if (!_showCreatePost && _auth.currentUser != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: const Icon(Icons.person, color: Colors.pink),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showCreatePost = true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'Share your thoughts, ask a question, or request help...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Category Filters
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) => setState(() => _selectedCategory = category),
                            backgroundColor: Colors.grey[200],
                            selectedColor: _getCategoryColor(category),
                            labelStyle: TextStyle(
                              color: _selectedCategory == category ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => setState(() => _selectedFilter = value),
                  itemBuilder: (context) => _filters.map((filter) {
                    return PopupMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  child: Row(
                    children: [
                      Text(_selectedFilter),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Create Post Card (when active)
          if (_showCreatePost && _auth.currentUser != null) _buildCreatePostCard(),

          // Community Posts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.pink));
                }

                if (snapshot.hasError) {
                  print('Firestore Error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading posts',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory == 'All'
                              ? 'No posts yet'
                              : 'No posts in $_selectedCategory',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                         Text(
                          'Be the first to share!',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        if (_auth.currentUser != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () => setState(() => _showCreatePost = true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                              child: const Text('Create First Post'),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                // Filter "Popular" posts in app
                List<DocumentSnapshot> filteredDocs = snapshot.data!.docs;
                if (_selectedFilter == 'Popular') {
                  filteredDocs.sort((a, b) {
                    final aData = a.data() as Map<String, dynamic>;
                    final bData = b.data() as Map<String, dynamic>;
                    final aLikes = List<dynamic>.from(aData['likes'] ?? []);
                    final bLikes = List<dynamic>.from(bData['likes'] ?? []);
                    return bLikes.length.compareTo(aLikes.length);
                  });
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildPostCard(data, doc.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _auth.currentUser != null && !_showCreatePost
          ? FloatingActionButton(
        onPressed: () => setState(() => _showCreatePost = true),
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}