import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_applicants_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_applicant_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

class ApplicantsScreen extends StatefulWidget {
  final String jobId;

  const ApplicantsScreen({Key? key, required this.jobId}) : super(key: key);

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    Future.microtask(() {
      final provider = Provider.of<ApplicantsProvider>(context, listen: false);
      provider.resetApplicants();
      provider.fetchApplicants(widget.jobId);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApplicantsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Applicants'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          // 🎊 Confetti at the top center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 20,
              gravity: 0.3,
              emissionFrequency: 0.1,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.orange],
            ),
          ),
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? Center(child: Text('Error: Could not load applicants'))
              : provider.applications.isEmpty
              ? _buildNoApplicantsWidget()
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: provider.applications.length + 1,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  if (index < provider.applications.length) {
                    final applicant = provider.applications[index];
                    return JobApplicantCard(
                      applicant: applicant,
                      onAccept: () async {
                        final success = await provider.updateStatus(
                          applicant.applicationId,
                          "Accepted",
                        );
                        if (success) {
                          _confettiController.play();
                        }
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "❌ Failed to accept applicant",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      onReject: () async {
                        final success = await provider.updateStatus(
                          applicant.applicationId,
                          "Rejected",
                        );
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "❌ Failed to reject applicant",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    if (provider.isAllLoaded) {
                      return const Center(child: Text('No more applicants.'));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              provider.loadMoreApplicants(widget.jobId);
                            },
                            child:
                                provider.isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Load More'),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
        ],
      ),
    );
  }

  Widget _buildNoApplicantsWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/No_Applicants.png',
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 24),
            Text(
              'No Applicants Yet!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Applicants will show here once people apply.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
