import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/bloc/candidate_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/bloc/candidate_event.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/bloc/candidate_state.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/models/candidate_model.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/widgets/hiring_stage_timeline.dart';
import 'package:url_launcher/url_launcher.dart';

class CandidateDetailScreen extends StatefulWidget {
  const CandidateDetailScreen({super.key});

  @override
  State<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedStageIndex = 0;
  List<HiringStage> _hiringStages = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CandidateBloc>(context).add(LoadCandidate());
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Candidate Details", style: AppTextStyles.appBar),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: BlocBuilder<CandidateBloc, CandidateState>(
        builder: (context, state) {
          if (state is CandidateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CandidateLoaded) {
            final candidate = state.candidateData.candidateDetails;
            _hiringStages = state.candidateData.hiringStages;

            // Set default stage to the one "in progress" only on first load
            if (_selectedStageIndex == 0) {
              final inProgressIndex = _hiringStages.indexWhere(
                (s) => s.statusName.toLowerCase() == 'in progress',
              );
              if (inProgressIndex != -1) {
                _selectedStageIndex = inProgressIndex;
              }
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40 : 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCandidateCard(candidate),
                  const SizedBox(height: 24),
                  HiringStageTimeline(
                    stages: _hiringStages,
                    selectedIndex: _selectedStageIndex,
                    onStageTap: (index) {
                      setState(() {
                        _selectedStageIndex = index;
                        _tabController.index = 0;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        indicatorWeight: 0,
                        indicatorColor: Colors.transparent,
                        controller: _tabController,
                        isScrollable: false,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        indicator: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryLight.withOpacity(0.1),
                        ),
                        tabs: [
                          _buildCustomTab(Icons.info_outline, "Overview"),
                          _buildCustomTab(
                              Icons.insert_drive_file_outlined, "Documents"),
                          _buildCustomTab(Icons.comment_outlined, "Remarks"),
                          _buildCustomTab(Icons.access_time, "Activity"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: 200,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildOverviewTab(),
                              _buildDocumentsTab(),
                              _buildRemarksTab(),
                              _buildActivityTab(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _applicationDetails(candidate)),
                          ],
                        )
                      : Column(
                          children: [
                            _applicationDetails(candidate),
                          ],
                        )
                ],
              ),
            );
          }

          if (state is CandidateError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _applicationDetails(candidate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Application Details", style: AppTextStyles.headline3),
          const SizedBox(height: 8),
          Text("Applied On", style: AppTextStyles.bodySmall),
          Text("Invalid Date", style: AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
          Text("Current Stage", style: AppTextStyles.bodySmall),
          Text("Phone Call", style: AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
          Text("Assigned To", style: AppTextStyles.bodySmall),
          Text("Not assigned", style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final selectedStage = _hiringStages[_selectedStageIndex];
    final status = selectedStage.statusName.toLowerCase();
    final isNotStarted = status == 'not started';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About ${selectedStage.hiringStageName}",
            style: AppTextStyles.headline3),
        const SizedBox(height: 8),
        Text(
          isNotStarted
              ? "This stage has not started yet."
              : "Details about this stage will be shown here.",
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDocumentsTab() {
    final selectedStage = _hiringStages[_selectedStageIndex];
    final status = selectedStage.statusName.toLowerCase();
    final isNotStarted = status == 'not started';

    return Center(
      child: Text(
        isNotStarted
            ? "This stage has not started yet."
            : "Documents Placeholder",
        style: AppTextStyles.bodySmall,
      ),
    );
  }

  Widget _buildRemarksTab() {
    final selectedStage = _hiringStages[_selectedStageIndex];
    final status = selectedStage.statusName.toLowerCase();
    final isNotStarted = status == 'not started';

    return Center(
      child: Text(
        isNotStarted
            ? "This stage has not started yet."
            : "Remarks Placeholder",
        style: AppTextStyles.bodySmall,
      ),
    );
  }

  Widget _buildActivityTab() {
    final selectedStage = _hiringStages[_selectedStageIndex];
    final status = selectedStage.statusName.toLowerCase();
    final isNotStarted = status == 'not started';

    return Center(
      child: Text(
        isNotStarted
            ? "This stage has not started yet."
            : "Activity Placeholder",
        style: AppTextStyles.bodySmall,
      ),
    );
  }

  Widget _buildCustomTab(IconData icon, String label) {
    return Tab(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateCard(CandidateDetails candidate) {
    final appliedDate = DateTime.tryParse(candidate.createdAt);
    final daysAgo = appliedDate != null
        ? DateTime.now().difference(appliedDate).inDays
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              "${candidate.firstName[0]}${candidate.lastName[0]}",
              style: AppTextStyles.headline2.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${candidate.firstName} ${candidate.lastName}",
                        style: AppTextStyles.headline2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Chip(
                      label: Text("Active",
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.success)),
                      backgroundColor: AppColors.success.withOpacity(0.15),
                      avatar: const Icon(Icons.check_circle,
                          color: AppColors.success, size: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email_outlined, candidate.email,
                    onTap: () => _launchEmail(candidate.email)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(candidate.phone, style: AppTextStyles.bodySmall),
                    const SizedBox(width: 24),
                    Icon(Icons.location_on_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        candidate.address,
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    launchUrl(emailUri);
  }
}
