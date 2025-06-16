import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final Map<String, List<Map<String, String>>> chapterVideos = {
    'Chapter 1 - Living World': [
      {
        'title': 'Part 1 - Introduction',
        'videoId': 'wAfjo53Cki0',
        'startAt': '7',
      },
      {
        'title': 'Part 2 - Classification',
        'videoId': 'jhjnqlQ_STA',
        'startAt': '7',
      },
    ],
    'Chapter 2 - Health & Disease': [
      {
        'title': 'Part 1 - Concepts',
        'videoId': 'MBNpEMlcxcQ',
        'startAt': '6',
      },
      {
        'title': 'Part 2 - Types of Diseases',
        'videoId': 'oRZ48gj23_g',
        'startAt': '6',
      },
      {
        'title': 'Part 3 - Prevention',
        'videoId': 'GYiP86nXrXE',
        'startAt': '6',
      },
    ],
  };

  bool _showAboutContent = true;

  void _navigateToVideoPlayer(String videoId, int startAt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoPlayerPage(videoId: videoId, startAt: startAt),
      ),
    );
  }

  void _toggleContent(bool showAbout) {
    setState(() {
      _showAboutContent = showAbout;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[800] ?? Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vidyarthi Saathi'),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/science2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Science',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _toggleContent(true),
                          child: _buildHeaderButton('About', _showAboutContent),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _toggleContent(false),
                          child: _buildHeaderButton(
                              'Refer Videos', !_showAboutContent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: _showAboutContent
                          ? _buildAboutContent()
                          : _buildVideoContent(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderButton(String text, bool isSelected) {
    final primaryColor = Colors.green[800] ?? Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : primaryColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'About Science',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800] ?? Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Science is a systematic enterprise that builds and organizes knowledge in the form of testable explanations and predictions about the universe. It is divided into three main branches: Physics, Chemistry, and Biology.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            'Key Features:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800] ?? Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('Comprehensive video lessons'),
          _buildFeatureItem('Interactive quizzes'),
          _buildFeatureItem('Chapter-wise study material'),
          _buildFeatureItem('Expert-verified content'),
          const SizedBox(height: 24),
          Text(
            'Science Chatbot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800] ?? Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our AI-powered chatbot can help you with any science-related questions. It can explain concepts, solve problems, and provide additional learning resources.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle,
              color: Colors.green[800] ?? Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChapterSection('Chapter 1 - Living World'),
          const SizedBox(height: 16),
          _buildChapterSection('Chapter 2 - Health & Disease'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildChapterSection(String chapterTitle) {
    final primaryColor = Colors.green[800] ?? Colors.green;
    final videos = chapterVideos[chapterTitle]!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  chapterTitle.contains('Living World')
                      ? Icons.biotech
                      : Icons.medical_services,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  chapterTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: videos.map((video) {
                return Column(
                  children: [
                    _buildVideoCard(
                      title: video['title']!,
                      videoId: video['videoId']!,
                      startAt: int.parse(video['startAt']!),
                    ),
                    if (video != videos.last) const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String videoId,
    required int startAt,
  }) {
    final primaryColor = Colors.green[800] ?? Colors.green;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _navigateToVideoPlayer(videoId, startAt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: 'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Tap to watch video',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final primaryColor = Colors.green[800] ?? Colors.green;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/home-btn.png", width: 24),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/resource-btn.png", width: 24),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/chatbot-btn.png", width: 24),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/quiz-btn.png", width: 24),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/profile-btn.png", width: 24),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final int startAt;

  const VideoPlayerPage({
    super.key,
    required this.videoId,
    required this.startAt,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  final primaryColor = Colors.green[800] ?? Colors.green;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        startAt: widget.startAt,
        useHybridComposition: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: primaryColor,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Video Lesson'),
            backgroundColor: primaryColor,
          ),
          body: Column(
            children: [
              player,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chapter Video',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'This video covers all the important concepts from this chapter. '
                          'Take notes while watching and pause when needed.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Reset orientation back to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
