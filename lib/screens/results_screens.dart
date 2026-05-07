import 'package:flutter/material.dart';
import '../models/focus_models.dart';

class ResultsScreen extends StatefulWidget {
  final SessionResponse response;

  const ResultsScreen({
    Key? key,
    required this.response,
  }) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getFocusScoreColor(String score) {
    switch (score.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF2E7D32);
      case 'good':
        return const Color(0xFF4CAF50);
      case 'fair':
        return const Color(0xFFF57F17);
      case 'needs improvement':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF757575);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.response.summary;
    final events = widget.response.events;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analysis Results'),
          elevation: 0,
          backgroundColor: const Color(0xFF6200EE),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            // Page 1: Summary Metrics
            _buildSummaryPage(summary),
            // Page 2: Timeline Events
            _buildTimelinePage(events, summary),
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF6200EE),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == 0 ? Colors.white : Colors.white54,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == 1 ? Colors.white : Colors.white54,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                '${_currentPage + 1} of 2',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryPage(Summary summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Focus Score Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getFocusScoreColor(summary.focusScore),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Focus Score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  summary.focusScore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${summary.focusPercentage.toStringAsFixed(1)}% Focus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Session Duration
          _buildMetricCard(
            icon: Icons.timer,
            label: 'Total Duration',
            value: summary.getDurationFormatted(summary.totalDurationSeconds),
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(height: 12),

          // Metrics Grid
          Row(
            children: [
              Expanded(
                child: _buildSmallMetricCard(
                  icon: Icons.check_circle,
                  label: 'Focus Time',
                  value: summary.getDurationFormatted(summary.focusTimeSeconds),
                  percentage: summary.focusPercentage,
                  color: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallMetricCard(
                  icon: Icons.cancel,
                  label: 'Distraction',
                  value: summary.getDurationFormatted(
                      summary.distractionTimeSeconds),
                  percentage: summary.distractionPercentage,
                  color: const Color(0xFFF44336),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Idle Time
          _buildMetricCard(
            icon: Icons.pause_circle,
            label: 'Idle Time',
            value: summary.getDurationFormatted(summary.idleTimeSeconds),
            color: const Color(0xFFFFC107),
          ),
          const SizedBox(height: 24),

          // Statistics
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatRow('Total Events', '${summary.eventCount}'),
                const SizedBox(height: 12),
                _buildStatRow(
                  'Avg Focus Duration',
                  summary.getDurationFormatted(
                      summary.focusTimeSeconds /
                          (summary.eventCount > 0 ? summary.eventCount : 1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Session ID
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, size: 16, color: Color(0xFF757575)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Video ID',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.response.videoId,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required double percentage,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF757575)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelinePage(List<FocusEvent> events, Summary summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Timeline',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${events.length} events detected',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 24),

          // Event Timeline
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final isLast = index == events.length - 1;

              return _buildTimelineEvent(event, isLast);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEvent(FocusEvent event, bool isLast) {
    final color = event.getEventColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Dot and Line
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 60,
                  color: color.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Event Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: color.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
                color: color.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.type.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        event.getDurationFormatted(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF212121),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${event.start.toStringAsFixed(0)}s - ${event.end.toStringAsFixed(0)}s',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}