import '../exports.dart';

class MatchCard extends StatelessWidget {
  final dynamic match;
  MatchCard({Key? key, required this.match}) : super(key: key);
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          if (match['status'] == 'Live') {
            // fetch stream url and navigate if available
            BuildContext? dialogContext;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext ctx) {
                dialogContext = ctx;
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).cardColor.withAlpha(250),
                          Theme.of(context).cardColor.withAlpha(235),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(31),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withAlpha(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withAlpha(31),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preparing Stream...',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Connecting to live broadcast.\n Please wait.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            try {
              String? streamUrl = await _apiService.fetchStreamUrl(match['id']);
              // Dismiss loading dialog
              if (dialogContext != null) {
                Navigator.of(dialogContext!).pop();
              }

              if (streamUrl.isNotEmpty) {
                Navigator.pushNamed(context, '/stream', arguments: streamUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stream not available'.tr())),
                );
              }
            } catch (e) {
              if (dialogContext != null) {
                Navigator.of(dialogContext!).pop();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load stream'.tr())),
              );
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Match is not live'.tr())));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: match['home_flag'],
                width: 40,
                height: 40,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${match['home_name']} vs ${match['away_name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match['league'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${match['date']} • ${match['time']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: match['status'] == 'Upcoming'
                                ? Colors.orange
                                : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            match['status'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CachedNetworkImage(
                imageUrl: match['away_flag'],
                width: 40,
                height: 40,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
