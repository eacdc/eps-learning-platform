import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/homeController/home_controller.dart';
import 'package:test_your_learing/views/custom_widgets/multisegment_circulsr_indicator.dart';

import '../../models/home_model/chapter_states_model.dart';
import 'multisegment_painter.dart';

class PerformanceOverviewCard extends StatefulWidget {
  final OverallStats? chapterStats;
    final ValueChanged<String> onChanged;

  const PerformanceOverviewCard({super.key, required this.chapterStats,required this.onChanged,});

  @override
  State<PerformanceOverviewCard> createState() =>
      _PerformanceOverviewCardState();
}

class _PerformanceOverviewCardState extends State<PerformanceOverviewCard> {
  String selectedPeriod = 'Weekly';
  final List<String> periods = ['Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    final chapterStats = widget.chapterStats;

    final totalbooks = chapterStats?.totalBooks ?? '-';
    final totalchapters = chapterStats?.totalChapters ?? '-';
    final completed = chapterStats?.completed?.count ??'-' ;
    final completed_percentage = (chapterStats?.completed?.percentage ?? 0)/100;
    final inProgress = chapterStats?.inProgress ?.count?? '-';
    final inProgress_percent =(chapterStats?.inProgress?.percentage??0)/100;
    final notStatrted = chapterStats?.notStarted?.count ?? '-';
    final notStatrted_perentag = (chapterStats?.notStarted?.percentage??0)/100;
    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(10),
      shadowColor: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Title and Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Performance Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedPeriod,
                  underline: SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items:
                      periods.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPeriod = newValue!;
                    });

                    widget.onChanged(newValue??"");
                    // recall the Api with new Date Format
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Circular Progress Indicator
            /* CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 12.0,
              percent: 0.75, // 75% complete

              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '145',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'hours',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey.shade200,
              circularStrokeCap: CircularStrokeCap.round,
            ),
 */
           
           
           Container(
            height: 120,
            width: 120,
             child: MultiSegmentCircle(
               completedPercent:completed_percentage,
               inProgressPercent: inProgress_percent,
               notStartedPercent: notStatrted_perentag,
               completedColor:Colors.green,
                  inProgressColor:Colors.orange,
               notStartedColor: Colors.red,
               
               ),
            

             
           ),

            const SizedBox(height: 16),

            /// Stats: Completed, In Progress, Not Started
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("$completed/$totalchapters", 'Completed', Colors.green),
                _buildStat(
                  "$inProgress/$totalchapters",
                  'In Progress',
                  Colors.orange,
                ),
                _buildStat(
                  "$notStatrted/$totalchapters",
                  'Not Started',
                  Colors.red,
                ),
              ],
            ),

            SizedBox(height: 16),
            /* SizedBox(
              height: 100,
              width: 100,
              child: MultiSegmentCircularIndicator(
                completedPercent: 0.5,
                inProgressPercent: 0.3,
                notStartedPercent: 0.2,
              ),
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
