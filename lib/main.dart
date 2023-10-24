import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/core/service_locator.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/home/view/home_view.dart';
import 'package:x/theme/theme.dart';

import 'features/auth/view/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
        data: (user) {
          if (user != null) {
            return const HomeView();
          }else{
            return const LoginView();
          }
        },
        error: (error, st) => ErrorPage(
          error: error.toString(),
        ),
        loading: () => const LoadingPage(),
      ),
    );
  }
}
