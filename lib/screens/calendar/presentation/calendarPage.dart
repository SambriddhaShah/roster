import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/calendar/bloc/calendar_bloc.dart';
import 'package:rooster_empployee/screens/notes/presentation/notePage.dart';
import 'package:rooster_empployee/utils/headerWidget.dart';
import 'package:rooster_empployee/utils/loadingScreen.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(InitialEvent(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarError) {
            ToastMessage.showMessage(state.error.message);
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    HeaderWidget(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                      DateFormat('MMMM d, yyyy')
                                          .format(DateTime.now()),
                                      style: AppTextStyles.caption),
                                  Text('Today', style: AppTextStyles.headline2),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: 40.h,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotesPage()));
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Add Note',
                                          style: AppTextStyles.button
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    )),
                              )
                            ],
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 90.h,
                            child: DatePicker(
                              DateTime.now(),
                              initialSelectedDate: _selectedDate,
                              selectionColor: AppColors.primary,
                              selectedTextColor: Colors.white,
                              onDateChange: (date) {
                                setState(() => _selectedDate = date);
                                context
                                    .read<CalendarBloc>()
                                    .add(SelectDateEvent(date));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('My Notes', style: AppTextStyles.headline3),
                      ],
                    ),
                    Expanded(
                      child: state is CalendarSuccessful
                          ? _buildTaskList(state.tasks)
                          : const Center(child: Text('No tasks found')),
                    ),
                  ],
                ),
                if (state is CalendarLoading) LoadingWidget(child: Container()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(List<dynamic> tasks) {
    return tasks.isEmpty
        ? const Center(child: Text('No tasks found'))
        : ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(int.parse(
                      '0x${task['color'].split('(0x')[1].split(')')[0]}')),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${task['title'].isEmpty ? 'Null' : task['title']}',
                            style: AppTextStyles.bodyLarge
                                .copyWith(color: Colors.white),
                          ),
                          Expanded(child: Container()),
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.white,
                            size: 15.sp,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '${DateFormat('yyyy-MM-dd').format(DateTime.parse(task['date']))}',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      // Divider(color: Colors.white,),

                      // SizedBox(height: 5.h),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     const Center(child: Icon(Icons.watch_later_outlined, color: Colors.white, )),
                      //     SizedBox(width: 2.w,),
                      //     Text('${task['startTime']} - ${task['endTime']}',style:AppTextStyles.bodySmall.copyWith(color: Colors.white),)
                      //   ],
                      // ),
                      SizedBox(height: 5.h),
                      Text(
                        '${task['note'].isEmpty ? 'Null' : task['note']}',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
