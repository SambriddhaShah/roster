import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/utils/headerWidget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Color _selectedColor = Colors.blue;
  List tasks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
          centerTitle: true,
          // automaticallyImplyLeading: false,
        ),
        body: PopScope(
          child: Stack(
            children: [
              HeaderWidget(),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTaskForm(),
                      SizedBox(height: 20.h),
                      _buildTaskList(tasks),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTaskForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note Title',
          style: AppTextStyles.headline3,
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Enter a title',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          'Description',
          style: AppTextStyles.headline3,
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            hintText: 'Enter the description of leave',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
        SizedBox(height: 15.h),
        Text(
          'Date',
          style: AppTextStyles.headline3,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.textPrimary)),
          child: ListTile(
            title: const Text('Date'),
            subtitle: Text(DateFormat.yMd().format(_selectedDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: _selectDate,
          ),
        ),
        SizedBox(height: 15.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Severity(${_selectedColor == Colors.blue ? 'Normal' : _selectedColor == Colors.orange ? 'Crucial' : 'Critical'})',
              style: AppTextStyles.headline3,
            ),
            SizedBox(
              height: 5.h,
            ),
            Wrap(
              spacing: 8,
              children: [Colors.blue, Colors.orange, Colors.red]
                  .map((color) => GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _selectedColor == color
                                ? Border.all(color: AppColors.primary, width: 2)
                                : null,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        SizedBox(height: 25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final taskData = {
                  'title': _titleController.text,
                  'note': _noteController.text,
                  'date': _selectedDate.toString(),
                  'color': _selectedColor.toString(),
                };
                setState(() {
                  tasks.add(taskData);
                  _titleController.clear();
                  _noteController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Create Note',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  // minimumSize: Size(double.infinity, 50.h),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskList(List<dynamic> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Added Notes', style: AppTextStyles.headline3),
        SizedBox(height: 10.h),
        ...tasks.map((task) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                )
            // ListTile(
            //       title: Text(task['title'], style: AppTextStyles.bodyText2(),),
            //       subtitle: Text(task['note']),
            //       leading: Container(
            //         width: 15.w,
            //         height: 15.h,
            //         decoration: BoxDecoration(
            //           color:Color(int.parse('0x${task['color'].split('(0x')[1].split(')')[0]}')) ,
            //           shape: BoxShape.circle,
            //         ),
            //       ),
            //       trailing: Text(DateFormat.jm().format(DateTime.parse(task['date']))),
            //     )

            ),
      ],
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitTask() {}

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
