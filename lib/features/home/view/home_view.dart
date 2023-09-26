
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/widgets/rounded_small_button.dart';
import 'package:x/features/auth/controller/auth_controller.dart';

class HomeView extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: RoundedSmallButton(onTap: () { ref.read(authControllerProvider.notifier).logout(context); }, label: 'logout',),
      ),
    );
  }
}
