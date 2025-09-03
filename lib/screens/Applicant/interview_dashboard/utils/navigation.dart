import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/utils/webView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

Future<void> openDocInAppWebView(
    BuildContext context, String absoluteUrl) async {
  final url = Platform.isAndroid
      ? 'https://docs.google.com/gview?embedded=1&url=$absoluteUrl'
      : absoluteUrl;

  // ignore: use_build_context_synchronously
  Navigator.push(
      context, MaterialPageRoute(builder: (_) => InAppWebViewPage(url: url)));
}

Future<void> launchExternalUrl(Uri uri) async {
  final ok = await canLaunchUrl(uri);
  if (!ok) {
    ToastMessage.showMessage('Could not launch file.');
    return;
  }
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Convenience for file paths that are relative to ApiUrl.imageUrl
Future<void> openApiFile(BuildContext context, String relativePath) async {
  final full = '${ApiUrl.imageUrl}$relativePath';
  await openDocInAppWebView(context, full);
}
