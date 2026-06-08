import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wardrobe_ai/services/history/history_grouping_service.dart';
import 'package:wardrobe_ai/widgets/safe_image.dart';

import '../../models/outfit_history.dart';

class OutfitHistoryScreen extends StatelessWidget {
  final List<OutfitHistory> history;

  const OutfitHistoryScreen({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {

    final grouped = HistoryGroupingService.groupHistory(history);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit History'),
      ),
      body: history.isEmpty
      ? const Center(
          child: Text(
            'No outfit history yet',
          ),
        )
      : ListView(
          padding: const EdgeInsets.all(16),
          children: grouped.entries.map(
            (group) {

              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 8,
                      top: 16,
                    ),
                    child: Text(
                      group.key,
                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  ...group.value.map(
                    (entry) {

                      return Card(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: entry.imagePaths.isNotEmpty
                                      ? SafeImage(
                                          path: entry.imagePaths.first,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.checkroom,
                                            size: 40,
                                          ),
                                        ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        entry.outfitName,
                                        style:
                                            const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        DateFormat(
                                          'dd MMM yyyy • hh:mm a',
                                        ).format(
                                          entry.wornOn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      );
                    },
                  ),
                ],
              );
            },
          ).toList(),
        ),
    );
  }
}