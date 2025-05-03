import '../../domain/entities/job_analytics_entity.dart';
import '../../../jobs/data/model/job_model.dart';
import '../../../jobs/domain/entities/job_entity.dart';

// class MostAppliedCompany {
//   final String id;
//   final int applicationCount;

//   MostAppliedCompany({required this.id, required this.applicationCount});

//   factory MostAppliedCompany.fromJson(Map<String, dynamic> json) {
//     return MostAppliedCompany(
//       id: json['_id'] ?? '',
//       applicationCount: json['applicationCount'] ?? 0,
//     );
//   }
// }

class JobAnalyticsModel extends JobAnalytics {
  JobAnalyticsModel({
    required int totalJobs,
    required MostAppliedCompany mostAppliedCompany,
    required Job mostAppliedJob, // Using the Job entity (backed by JobModel)
  }) : super(
         totalJobs: totalJobs,
         mostAppliedCompany: mostAppliedCompany,
         mostAppliedJob: mostAppliedJob,
       );

  factory JobAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return JobAnalyticsModel(
      totalJobs: json['totalJobs'] ?? 0,
      mostAppliedCompany: MostAppliedCompany.fromJson(
        json['mostAppliedCompany'] ?? {},
      ),
      mostAppliedJob: JobModel.fromJson(json['mostAppliedJob'] ?? {}),
    );
  }
}
