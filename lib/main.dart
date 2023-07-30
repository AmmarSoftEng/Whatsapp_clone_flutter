import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widget/error.dart';
import 'package:whatsapp/common/widget/loder.dart';
import 'package:whatsapp/features/auth/controller/auth_contriller.dart';
import 'package:whatsapp/features/landing/screen/landing_screen.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/routet.dart';
import 'package:whatsapp/screens/mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModle;

  void getUser(UserModel user) async {
    userModle = await ref
        .read(authControllerProvider.notifier)
        .getUserData(user.uid)
        .first;
    ref.read(uProvider.notifier).update((state) => userModle);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
          data: (data) {
            if (data != null) {
              return MobileLayoutScreen();
            }
            return LandingScreen();
          },
          error: (error, trace) => ErrorScreen(error: error.toString()),
          loading: () => Loder()),
    );
  }
}


// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Whatsapp UI',
//         theme: ThemeData.dark().copyWith(
//           scaffoldBackgroundColor: backgroundColor,
//         ),
//         onGenerateRoute: (settings) => generateRoute(settings),
//         home: LandingScreen()
//         // ref.watch(userProvider).when(
//         //     data: (data) {
//         //       if (data != null) {
//         //         return MobileLayoutScreen();
//         //       }
//         //       return LandingScreen();
//         //     },
//         //     error: (error, trace) => ErrorScreen(error: error.toString()),
//         //     loading: () => Loder()),
//         );
//   }
// }
