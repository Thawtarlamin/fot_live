import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

// Keep titles/text as constants
const String apptitle = 'Live Stream';
const String about =
  'Enjoy the live stream. Use the controls to pause, seek (if supported), or go full screen. If you have issues, try Retry.';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  // use theme's color for the spinner
  return CircularProgressIndicator(
    color: Theme.of(context).colorScheme.secondary,
    strokeWidth: 3.0,
  );
  }
}

class StreamPlayerScreen extends StatefulWidget {
  final String url;
  final String? refer;

  const StreamPlayerScreen({super.key, required this.url, this.refer});

  @override
  State<StreamPlayerScreen> createState() => _StreamPlayerScreenState();
}

class _StreamPlayerScreenState extends State<StreamPlayerScreen> {
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  final spin = const Loading();

  @override
  void initState() {
  super.initState();
  // wait for first frame so Theme.of(context) is safe
  WidgetsBinding.instance.addPostFrameCallback((_) {
    videoChewieController();
  });
  }

  void videoChewieController() {
  final theme = Theme.of(context);
  final colorPrimary = theme.colorScheme.primary;
  final colorOnPrimary = theme.colorScheme.onPrimary;
  final bgForControls = theme.brightness == Brightness.dark ? Colors.black87 : Colors.white;
  final iconColor = theme.iconTheme.color ?? colorOnPrimary;

  const String agent =
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.99 Safari/537.36";

  // dispose previous controllers if any
  try {
    videoPlayerController?.dispose();
  } catch (_) {}
  try {
    chewieController?.dispose();
  } catch (_) {}

  if (widget.refer?.isNotEmpty ?? false) {
    videoPlayerController = VideoPlayerController.network(
    widget.url,
    httpHeaders: {'Referer': widget.refer!, 'User-Agent': agent},
    );
  } else {
    videoPlayerController = VideoPlayerController.network(widget.url);
  }

  double getAspectRatio() {
    try {
    final ratio = videoPlayerController!.value.aspectRatio;
    if (ratio > 0.0) return ratio;
    } catch (_) {}
    return 16 / 9;
  }

  setState(() {
    chewieController = ChewieController(
    videoPlayerController: videoPlayerController!,
    aspectRatio: getAspectRatio(),
    allowedScreenSleep: false,
    autoPlay: true,
    looping: false,
    isLive: true,
    showControls: true,
    allowFullScreen: true,
    autoInitialize: true,
    // use theme colors (can't be const)
    customControls: CupertinoControls(
      backgroundColor: bgForControls,
      iconColor: iconColor,
      showPlayButton: false,
    ),
    errorBuilder: (context, errorMessage) {
      return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
          Icons.warning_amber_rounded,
          color: theme.colorScheme.error,
          size: 56,
          ),
          const SizedBox(height: 12),
          Text(
          "Playback Error",
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color ?? colorOnPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 8),
          Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: theme.textTheme.labelLarge?.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back"),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
            ),
            onPressed: () {
              // re-create controller to retry
              videoChewieController();
            },
            child: const Text("Retry"),
            ),
          ],
          ),
        ],
        ),
      ),
      );
    },
    placeholder: Container(
      color: bgForControls,
      child: Center(child: spin),
    ),
    );
  });
  }

  @override
  void dispose() {
  try {
    videoPlayerController?.dispose();
  } catch (_) {}
  try {
    chewieController?.dispose();
  } catch (_) {}
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final cardColor = theme.cardColor;
  final scaffoldBg = theme.scaffoldBackgroundColor;
  final accent = theme.colorScheme.secondary;
  final onAccent = theme.colorScheme.onSecondary;
  final titleStyle = theme.textTheme.titleLarge?.copyWith(
    color: accent,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  return Scaffold(
    backgroundColor: scaffoldBg,
    appBar: AppBar(
    title: Text(apptitle, style: TextStyle(color: theme.appBarTheme.titleTextStyle?.color ?? theme.textTheme.titleLarge?.color)),
    backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
    elevation: 0,
    actions: [
      IconButton(
      icon: Icon(Icons.info_outline, color: theme.iconTheme.color?.withOpacity(0.85)),
      onPressed: () {
        showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: cardColor,
          title: Text(
          'About',
          style: TextStyle(color: theme.textTheme.titleMedium?.color),
          ),
          content: Text(
          about,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85)),
          ),
          actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
            'Close',
            style: TextStyle(color: accent),
            ),
          ),
          ],
        ),
        );
      },
      ),
    ],
    ),
    body: Column(
    children: [
      // Video area with rounded corners and subtle shadow
      Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          ],
        ),
        height: MediaQuery.of(context).size.width * 9 / 16,
        // show chewie only when controller ready
        child: chewieController != null
          ? Chewie(controller: chewieController!)
          : Container(color: Colors.black87, child: Center(child: spin)),
        ),
      ),
      ),
      // Info card
      Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white10),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
          apptitle,
          style: titleStyle,
          ),
          const SizedBox(height: 8),
          Text(
          about,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85)),
          textAlign: TextAlign.left,
          ),
          const Spacer(),
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: onAccent,
            ),
            onPressed: () {
              videoChewieController();
            },
            ),
          ],
          ),
        ],
        ),
      ),
      ),
      const SizedBox(height: 12),
    ],
    ),
  );
  }
}
