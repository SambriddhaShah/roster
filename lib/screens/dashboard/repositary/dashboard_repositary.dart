
import 'dart:convert';

import 'package:rooster_empployee/screens/dashboard/models/dashboardData.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';

class Dashboardrepository {
  final ApiService apiService;

  Dashboardrepository(this.apiService);
 Future<DashboardData?> getDashboardData() async {
    // Replace with actual API call later
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final userData= await FlutterSecureData.getUserData();
    final dynamic user= jsonDecode(userData??'{}');
    final sendData= await FlutterSecureData.getTodo()??'false';
    DateTime now = DateTime.now().add(Duration(minutes: 2));
    DateTime then = DateTime.now().add(Duration(minutes: 6));
DateTime startTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
DateTime endTime = DateTime(then.year, then.month, then.day, then.hour, then.minute);

    if(sendData=='true'){
      return DashboardData(
      employeeName: '${user['firstName']??'name'} ${user['lastName']??''}',
      employeeEmail: user['email']??'email',
      employeeId: 'ROO-2345',
      taskTitle: 'Client Meeting Preparation',
      taskDescription: 'Prepare presentation and documents for client meeting',
      location: 'Office Building A, Floor 12',
      startTime: startTime,
      endTime: endTime,
    );

    }else{
      return null;
    }
    
    
  }
}