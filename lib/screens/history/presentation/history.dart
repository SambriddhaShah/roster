import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/history/bloc/history_bloc.dart';
import 'package:rooster_empployee/screens/history/models/taskData.dart';
import 'package:rooster_empployee/utils/headerWidget.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc()..add(LoadHistoryEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('History'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const HeaderWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.77,
                child: BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoading) {
                      print('loading');
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HistoryError) {
                      ToastMessage.showMessage('Error Occured');
                      return Center(child: Text(state.error));
                    } else if (state is HistoryLoaded) {
                      print('loaded');
                      print('the data is ${state.tasks}');
                      return Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Completed Task",
                                style: AppTextStyles.headline3
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                             SizedBox(height: 12.h),
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.69,
                              child: ListView.builder(
                                
                                padding: const EdgeInsets.all(16),
                                itemCount: state.tasks.length,
                                itemBuilder: (context, index) {
                                  final task = state.tasks[index];
                                  return GestureDetector(
                                    onTap: () =>
                                        _showTaskDetails(context, task),
                                    child: _buildTaskCard(context, task),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(child: Text('No history available'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, HistoryData task) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin:  EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color:task.isLate=='false'? AppColors.primary:Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                task.taskTitle,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
              const Spacer(),
              const Icon(Icons.calendar_month_outlined,
                  color: Colors.white, size: 15),
              const SizedBox(width: 5),
              Text(
                DateFormat('yyyy-MM-dd').format(task.startTime),
                style: AppTextStyles.caption.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.watch_later_outlined, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            task.taskDescription,
            style: AppTextStyles.caption.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                task.location,
                style: AppTextStyles.caption.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, HistoryData task) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      backgroundColor: AppColors.background,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              SizedBox(
                width: MediaQuery.of(context).size.width*0.55,
                child: Row(
                  children: [
                    Icon(Icons.task_outlined, color: AppColors.primary, size: 20.sp),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        task.taskTitle,
                        style: AppTextStyles.headline3.copyWith(color: AppColors.primaryDark),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                task.taskDescription,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),

              // Time and Date
              _buildDetailRow(
                icon: Icons.watch_later_outlined,
                title: 'Time',
                value: '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
              ),
              _buildDetailRow(
                icon: Icons.date_range_outlined,
                title: 'Date',
                value: DateFormat('MMMM d, yyyy').format(task.startTime),
              ),
              const SizedBox(height: 20),

              // Location
              _buildDetailRow(
                icon: Icons.location_on_outlined,
                title: 'Location',
                value: task.location,
              ),
              const SizedBox(height: 20),

              // Employee Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed By',
                      style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.employeeName,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      task.employeeEmail,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Close Button
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.button.copyWith(color: AppColors.surface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildDetailRow({required IconData icon, required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}
