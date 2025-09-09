import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_your_learing/models/score_model/unified_score.dart';

class AssesmentDataCard extends StatefulWidget {
  final AssessmentData? assesmentData;

  const AssesmentDataCard({super.key, required this.assesmentData});

  @override
  State<AssesmentDataCard> createState() => _PerformanceOverviewCardState();
}

class _PerformanceOverviewCardState extends State<AssesmentDataCard> {
  @override
  Widget build(BuildContext context) {
    final assesmentData = widget.assesmentData;

    final recomendation_list = assesmentData?.recommendations ?? [];
    final subjectAnalysis = assesmentData?.subjectAnalysis ?? [];

    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(10),
      shadowColor: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
             Align(
               alignment: Alignment.centerLeft,
               child: const Text(
                 'Performance Metrics',
                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
               ),
             ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  _buildStat("$completed/$totalchapters", 'Completed', Colors.green),
                _buildStat(
                  assesmentData?.totalAssessments?.toString() ?? "",
                  "Total Assessments",
                ),
                const SizedBox(width: 10),
                _buildStat(
                  assesmentData?.performanceMetrics?.totalQuestions
                          ?.toString() ??
                      "",
                  "Total Questions",
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  _buildStat("$completed/$totalchapters", 'Completed', Colors.green),
                _buildStat(
                  assesmentData?.performanceMetrics?.avgScore.toString() ?? "",
                  "Avg Score",
                ),
                const SizedBox(width: 10),
                _buildStat(
                  assesmentData?.performanceMetrics?.accuracyRate?.toString() ??
                      "",
                  "Accuracy Rate",
                ),
              ],
            ),
            Visibility(
              visible: subjectAnalysis.isNotEmpty,
              child: const SizedBox(height: 16),
            ),

            Visibility(
              visible: subjectAnalysis.isNotEmpty,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Subject Analysis',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Visibility(
              visible: subjectAnalysis.isNotEmpty,
              child: const SizedBox(height: 8),
            ),

            Visibility(
              visible: subjectAnalysis.isNotEmpty,
              child: Container(
                height: 100,
                margin: EdgeInsets.only(left: 0, right: 4, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                //padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjectAnalysis.length,
                  itemBuilder: (context, index) {
                    final item = subjectAnalysis[index];
                    return Container(
                      width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.subject}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Attempted',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                item?.attempted?.toString() ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Accuracy',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(formatAccuracy(item?.accuracy)
                               ,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          )
                     ,  SizedBox(height: 0),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'AvgScore',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(

                                formatAccuracy(item?.avgScore),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          )
                       
                       
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            Visibility(
              visible: recomendation_list.isNotEmpty,
              child: const SizedBox(height: 16),
            ),

            Visibility(
              visible: recomendation_list.isNotEmpty,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Recommendations',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Visibility(
              visible: recomendation_list.isNotEmpty,
              child: const SizedBox(height: 2),
            ),

            Visibility(
              visible: recomendation_list.isNotEmpty,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recomendation_list.length,
                  itemBuilder: (context, index) {
                    final item = recomendation_list[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• $item",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox.shrink(),
                ),
              ),
            ),

            ///*  */ SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  String formatAccuracy(double? value) {
  if (value == null) {
    return "";
  }
  return value.toStringAsFixed(2);
}

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
