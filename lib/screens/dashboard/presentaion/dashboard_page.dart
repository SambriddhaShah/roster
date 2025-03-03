import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:rooster_empployee/screens/dashboard/models/dashboardData.dart';
import 'package:rooster_empployee/screens/history/models/taskData.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/service/geoLocation_service.dart';
import 'package:rooster_empployee/service/locationService.dart';
import 'package:rooster_empployee/service/notiService.dart';
import 'package:rooster_empployee/utils/drawer.dart';
import 'package:rooster_empployee/utils/headerWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:workmanager/workmanager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isCheckedIn = false;
  late DateTime currentTime;
  DateTime? checkOutTime;
  DateTime? checkInTime;
  Timer? _locationCheckTimer;
  bool _isWithinRadius = false;
  final double _allowedRadius = 10;
  Position? _currentPosition;
  // Add work location coordinates (get from your backend)
  // final LatLng workLocation = LatLng(37.4219983, -122.084);
  // Create a Position object
  Position? workLocation;
  bool isCheckOutLoading = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    getWorkLocation();
    currentTime = DateTime.now();
    context.read<DashboardBloc>().add(InitialEvent());
    // _startLocationUpdates();
  }

  bool isTracking = false;

  void _toggleTracking() async {
    if (isTracking) {
      await LocationService.stopLocationTracking();
    } else {
      await LocationService.startLocationTracking();
    }

    setState(() {
      isTracking = !isTracking;
    });
  }

  void _scheduleLocationCheck() {
    Workmanager().registerPeriodicTask('uniqueTaskId', 'perodicLocationCheck',
        frequency: const Duration(minutes: 15)
        // initialDelay: const Duration(seconds:10), // Trigger after 5 minutes
        );
  }

  String _formatTime(DateTime time) => DateFormat('h:mm a').format(time);

  void getWorkLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      workLocation = position;
    });
    print(
        'the work latitide is ${workLocation!.latitude} and the longitide is ${workLocation!.longitude}');
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    // Check if permission is already granted
    var status = await Permission.location.status;
    if (!status.isGranted) {
      // Request permission if not granted
      await Permission.location.request();
    }

    // Check if permission is still denied
    if (await Permission.location.isDenied) {
      // Handle the case when the user denies permission
      print("Location permission denied");
    } else if (await Permission.location.isPermanentlyDenied) {
      // If the user has permanently denied the permission
      openAppSettings(); // Optionally, open app settings to allow the user to change the permission
    }
  }

  // void _startLocationUpdates() {
  //   _locationCheckTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
  //     await _checkLocationValidity();
  //   });
  // }

  Future<bool> _checkLocationValidity() async {
    final position = await LocationServicee.getCurrentLocation();
    if (position != null) {
      final distance = LocationServicee.calculateDistance(
        position.latitude,
        position.longitude,
        workLocation!.latitude,
        workLocation!.longitude,
      );
      print(
          'the work latitide is ${workLocation!.latitude} and the longitide is ${workLocation!.longitude} and mine latitude is ${position.latitude} and the longitide is ${position.longitude} and the distance is $distance');

      setState(() {
        _isWithinRadius = distance <= _allowedRadius;
        print('the result is ${_isWithinRadius = distance <= _allowedRadius}');
      });
      if (_isWithinRadius) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
      print('the location is null');
    }
  }

  Future<void> _handleCheckIn(DateTime taskStartTime, DateTime endTime) async {
    await _checkLocationValidity();

    if (!_isWithinRadius) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Mismatch'),
          content:
              const Text('You must be within 10m of work location to check-in'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    } else {
      final lateDuration = DateTime.now().difference(taskStartTime);
      if (lateDuration.inMinutes > 0) {
        setState(() {
          _currentPosition = null;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Late Check-in'),
            content: Text('You are ${lateDuration.inMinutes} minutes late!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      } else {
        await FlutterSecureData.setisCheckdIn('true');
        // Proceed with check-in
        final position = await LocationServicee.getCurrentLocation();
        _toggleTracking();
        //  NotiService().showPerodicNotification(title: 'Prodic Notification', body: 'Hello this is the first one');
        NotiService().showNotification(
            title: 'Work Started!', body: 'You have checked in to the work');
        NotiService().showScheduledNotification(
            title: 'Checkout Time!',
            body: 'You have completed the work Checkout please!',
            minute: (DateTime.now().difference(endTime).inMinutes).abs());
        //  works but why use workmanager when can do with local notifications
        //  _scheduleDelayedNotification(endTime);
        setState(() {
          isCheckedIn = true;
          checkInTime = DateTime.now();
          _currentPosition = position;
        });
        // BackgroundService.scheduleLocationValidation();
        // _scheduleLocationCheck();
        ToastMessage.showMessage('Attendance Taken: Checked In');
      }
    }
  }

// schedule workmanager notifications
  void _scheduleDelayedNotification(DateTime taskEnd) {
    final end = DateTime.now().difference(taskEnd);
    print('the delayed minutes are ${end.inMinutes} and ${end}');
    Workmanager().registerOneOffTask(
      'uniqueTaskId',
      'delayedNotification',
      initialDelay: Duration(minutes: (end.inMinutes).abs()),
    );
  }

  // Add to your existing build method
  Widget _buildLocationStatus() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            _isWithinRadius ? Icons.check_circle : Icons.error,
            color: _isWithinRadius ? AppColors.success : AppColors.error,
          ),
          SizedBox(width: 8),
          Text(
            _isWithinRadius ? 'Within work area (10m)' : 'Outside work area',
            style: AppTextStyles.bodySmall.copyWith(
              color: _isWithinRadius ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  // void _handleCheckIn(DateTime taskStartTime) {
  //   final lateDuration = currentTime.difference(taskStartTime);
  //   if (lateDuration.inMinutes > 0) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Late Check-in'),
  //         content: Text('You are ${lateDuration.inMinutes} minutes late!'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //     return;
  //   }
  //   setState((){
  //     isCheckedIn = true;
  //     checkInTime= DateTime.now();
  //   } );
  // }

  Future<void> _handleCheckOut(
      DateTime taskEndTime, DashboardData data, BuildContext contextt) async {
    final lateDuration = taskEndTime.difference(DateTime.now());
    await _checkLocationValidity();
    if (!_isWithinRadius) {
      showDialog(
        context: contextt,
        builder: (context) => AlertDialog(
          title: const Text('Location Mismatch'),
          content: const Text(
              'You must be within 10m of work location to check-out'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    } else {
      if (lateDuration.inMinutes <= 0) {
        setState(() {
          isCheckedIn = false;
          checkOutTime = DateTime.now();
        });
        print('late duration is ${lateDuration.inMinutes}');
        final newtaskData = HistoryData(
            employeeEmail: data.employeeEmail,
            employeeName: data.employeeName,
            endTime: checkOutTime ?? data.endTime,
            startTime: checkInTime ?? data.startTime,
            taskDescription: data.taskDescription,
            taskTitle: data.taskTitle,
            location: data.location,
            isLate: 'false');
        _toggleTracking();
        NotiService().showNotification(
            title: 'Checked Out!', body: 'You have checked out from the work');
        // Dispatch CheckOutEvent after the check-out is handled
        contextt.read<DashboardBloc>().add(CheckOutEvent(data: newtaskData));

        // BackgroundService.cancelLocationValidation();
      } else {
        showDialog(
          context: contextt,
          builder: (context) => AlertDialog(
            title: const Text('Early Checkout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'You are checking-out ${lateDuration.inMinutes} minutes early'),
                TextField(
                  decoration: InputDecoration(
                      label: Text('Reason'), hintText: 'Enter reason'),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    isCheckedIn = false;
                    checkOutTime = DateTime.now();
                    // context.read<DashboardBloc>().add(InitialEvent());
                  });
                  final newtaskData = HistoryData(
                      employeeEmail: data.employeeEmail,
                      employeeName: data.employeeName,
                      endTime: checkOutTime ?? data.endTime,
                      startTime: checkInTime ?? data.startTime,
                      taskDescription: data.taskDescription,
                      taskTitle: data.taskTitle,
                      location: data.location,
                      isLate: 'true');
                  _toggleTracking();
                  NotiService().showNotification(
                      title: 'Checked Out!',
                      body: 'You have checked out from the work');

                  // Dispatch CheckOutEvent after the check-out is handled
                  contextt
                      .read<DashboardBloc>()
                      .add(CheckOutEvent(data: newtaskData));

                  Navigator.pop(context);

                  // BackgroundService.cancelLocationValidation();
                },
                child: const Text('Checkout Early'),
              ),
            ],
          ),
        );
        ToastMessage.showMessage('Not time to checkout');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardCheckOutLoading) {
            print('checkout loading');
            setState(() {
              isCheckOutLoading = true;
            });
          } else if (state is DashboardLoading) {
            setState(() {
              isCheckOutLoading = false;
            });
          }
        },
        builder: (context, state) {
          if (state is DashboardSuccessful) {
            final dashboardData = state.data;
            return _buildDashboardContent(dashboardData, state.userData);
          } else if (state is DashboardError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDashboardContent(DashboardData? data, dynamic userData) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(),
          Container(
            margin: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(),
                _buildEmployeeCard(userData),
                SizedBox(height: 20.h),
                _buildPerformanceSection(),
                _buildTaskCard(data),
                //  SizedBox(height: 20.h),
                // _buildCheckInCard(data),
                SizedBox(
                  height: 20.h,
                ),
                _buildTodaysStatusSection(data, context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: AppTextStyles.headline2.copyWith(color: AppColors.primary),
        ),
        Text(
          DateFormat('MMMM d, yyyy').format(DateTime.now()),
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmployeeCard(dynamic data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.r,
            backgroundImage:
                (data['profileImage'] == null || data['profileImage'].isEmpty)
                    ? const AssetImage('assets/defaultprofileimage.png')
                    : FileImage(File(data['profileImage'])),
          ),
          //  CircleAvatar(
          //   backgroundColor: Colors.white,
          //   radius: 30.r,
          //   backgroundImage: AssetImage('assets/defaultprofileimage.png'),
          // ),
          title: Text('${data['firstName']} ${data['lastName']}',
              style: AppTextStyles.headline3.copyWith(color: Colors.white)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['email'],
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
              Text('Employee ID: ${data['employeeId']}',
                  style: AppTextStyles.caption.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(DashboardData? data) {
    return Card(
      color: AppColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Task",
              style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            data == null
                ? Center(
                    child: Text(
                      'Task Completed',
                      style: AppTextStyles.caption,
                    ),
                  )
                : Container(
                    // margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
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
                                data.taskTitle,
                                style: AppTextStyles.bodySmall
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
                                DateFormat('yyyy-MM-dd').format(data.startTime),
                                style: AppTextStyles.caption
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          // Divider(color: Colors.white,),

                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Center(
                                  child: Icon(
                                Icons.watch_later_outlined,
                                color: Colors.white,
                              )),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                '${_formatTime(data.startTime)} - ${_formatTime(data.endTime)}',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            data.taskDescription,
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.surface,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                data.location,
                                style: AppTextStyles.caption
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )

            // _buildTaskDetail('Title', data.taskTitle),
            // _buildTaskDetail('Description', data.taskDescription),
            // _buildTaskDetail('Location', data.location),
            // _buildTaskDetail('Work Duration', '8 hours'),
            // _buildTaskDetail('Date', DateFormat('MMMM d, yyyy').format(data.startTime)),
            // _buildTaskDetail('Check-in Time', _formatTime(data.startTime)),
            // _buildTaskDetail('Check-out Time', _formatTime(data.endTime)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysStatusSection(DashboardData? data, BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Status",
              style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            data == null
                ? Center(
                    child: Text(
                    'Task Completed',
                    style: AppTextStyles.caption,
                  ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusColumn(
                          'Check In', _formatTime(data!.startTime)),
                      SizedBox(
                        width: 50.w,
                      ),
                      _buildStatusColumn(
                          'Check Out', _formatTime(data!.endTime)),
                    ],
                  ),
            const SizedBox(height: 20),
            data == null
                ? SizedBox.shrink()
                : _buildSliderButton(data, context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusColumn(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.bodyLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value ?? '--/--',
            style:
                AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Card(
      color: AppColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Performance",
              style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRatingGauge(),
                _buildPunctualityGauge(),
                _buildTasksGauge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingGauge() {
    return SizedBox(
        width: 105.w,
        height: 150.h,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: 5,
              showLabels: false,
              showTicks: false,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: const <GaugePointer>[
                RangePointer(
                  value: 4.5,
                  cornerStyle: CornerStyle.bothCurve,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('4.5/5',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.primary)),
                      Text('Ratings', style: AppTextStyles.caption),
                    ],
                  ),
                )
              ])
        ]));
  }

  Widget _buildPunctualityGauge() {
    return SizedBox(
        width: 105.w,
        height: 150.h,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: 100,
              interval: 20,
              showLabels: false,
              showTicks: false,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: const <GaugePointer>[
                RangePointer(
                  value: 85,
                  cornerStyle: CornerStyle.bothCurve,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('85%',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.primary)),
                      Text('Punctuality', style: AppTextStyles.caption),
                    ],
                  ),
                )
              ])
        ]));
  }

  Widget _buildTasksGauge() {
    return SizedBox(
        width: 105.w,
        height: 150.h,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: 40,
              interval: 10,
              showLabels: false,
              showTicks: false,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: const <GaugePointer>[
                RangePointer(
                  value: 4.5,
                  cornerStyle: CornerStyle.bothCurve,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('30/40',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.primary)),
                      Text('Completed', style: AppTextStyles.caption),
                    ],
                  ),
                )
              ])
        ]));
  }

  // Widget _buildPunctualityGauge() {
  //   return SizedBox(
  //     width: 100,
  //     height: 150,
  //     child: SfRadialGauge(
  //       axes: <RadialAxis>[
  //         RadialAxis(
  //           minimum: 0,
  //           maximum: 100,
  //           interval: 20,
  //           ranges: <GaugeRange>[
  //             GaugeRange(
  //                 startValue: 0, endValue: 85, color: AppColors.primaryLight),
  //           ],
  //           pointers: <GaugePointer>[
  //             NeedlePointer(
  //               value: 85,
  //               needleColor: AppColors.primary,
  //             )
  //           ],
  //           annotations: <GaugeAnnotation>[
  //             GaugeAnnotation(
  //                 widget: Column(
  //                   children: [
  //                     Text('85%',
  //                         style: AppTextStyles.bodyLarge
  //                             .copyWith(color: AppColors.primary)),
  //                     Text('Punctuality', style: AppTextStyles.caption),
  //                   ],
  //                 ),
  //                 angle: 90,
  //                 positionFactor: 0.1)
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildTasksGauge() {
  //   return SizedBox(
  //     width: 100,
  //     height: 150,
  //     child: SfRadialGauge(
  //       axes: <RadialAxis>[
  //         RadialAxis(
  //           minimum: 0,
  //           maximum: 40,
  //           interval: 10,
  //           ranges: <GaugeRange>[
  //             GaugeRange(
  //                 startValue: 0, endValue: 30, color: AppColors.primaryLight),
  //           ],
  //           pointers: <GaugePointer>[
  //             NeedlePointer(
  //               value: 30,
  //               needleColor: AppColors.primary,
  //             )
  //           ],
  //           annotations: <GaugeAnnotation>[
  //             GaugeAnnotation(
  //                 widget: Column(
  //                   children: [
  //                     Text('30/40',
  //                         style: AppTextStyles.bodyLarge
  //                             .copyWith(color: AppColors.primary)),
  //                     Text('Completed', style: AppTextStyles.caption),
  //                   ],
  //                 ),
  //                 angle: 90,
  //                 positionFactor: 0.5)
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSliderButton(DashboardData data, BuildContext context) {
    return isCheckOutLoading
        ? Center(child: CircularProgressIndicator(color: AppColors.primary))
        : SlideAction(
            height: 60,
            sliderButtonIcon:
                const Icon(Icons.arrow_forward, color: AppColors.surface),
            sliderButtonIconPadding: 12,
            sliderButtonIconSize: 24,
            text: isCheckedIn ? 'Slide to Check Out' : 'Slide to Check In',
            textStyle: AppTextStyles.button.copyWith(color: AppColors.surface),
            outerColor: AppColors.primaryLight,
            innerColor: AppColors.primaryDark,
            borderRadius: 15.r,
            elevation: 2,
            onSubmit: () async {
              // Check-in/out based on the current state
              if (isCheckedIn) {
                await _handleCheckOut(data.endTime, data, context);
              } else {
                await _handleCheckIn(data.startTime, data.endTime);
              }
            },
          );
  }

//   Widget _buildSliderButton(DashboardData data , BuildContext context) {
//     return isCheckOutLoading?Center(child:CircularProgressIndicator(color: AppColors.primary,)) :SlideAction(
//       height: 60,
//       sliderButtonIcon:
//           const Icon(Icons.arrow_forward, color: AppColors.surface),
//       sliderButtonIconPadding: 12,
//       sliderButtonIconSize: 24,
//       text: isCheckedIn ? 'Slide to Check Out' : 'Slide to Check In',
//       textStyle: AppTextStyles.button.copyWith(color: AppColors.surface),
//       outerColor: AppColors.primaryLight,
//       innerColor: AppColors.primaryDark,
//       borderRadius: 15.r,
//       elevation: 2,
//       onSubmit: () async {
//         // if (!_isWithinRadius) {
//         //   ToastMessage.showMessage('Move closer to work location');
//         //   // ScaffoldMessenger.of(context).showSnackBar(
//         //   //   SnackBar(content: Text('Move closer to work location')),
//         //   // );
//         //   return;
//         // }

//         if (isCheckedIn) {
//           _handleCheckOut(data.endTime, data, context).then((value){

//         final newtaskData = HistoryData(
//             employeeEmail: data.employeeEmail,
//             employeeName: data.employeeName,
//             endTime: data.endTime,
//             startTime: data.startTime,
//             taskDescription: data.taskDescription,
//             taskTitle: data.taskTitle,
//             location: data.location);
//               context.read<DashboardBloc>().add(CheckOutEvent(data: newtaskData));
//           });
//         } else {
//           await _handleCheckIn(data.startTime);
//         }
//       },
//       // () {
//       //   if (isCheckedIn) {
//       //     _handleCheckOut(data.endTime);
//       //   } else {
//       //     _handleCheckIn(data.startTime);
//       //   }
//       //   return null;
//       // },
//     );
//   }
}
