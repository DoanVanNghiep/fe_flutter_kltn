import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnua_service/route/route_constants.dart' as router;
import 'package:vnua_service/splash/splash_cubit.dart';
import 'package:vnua_service/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..checkAuthentication(),
      child: const _SplashScreenBody(),
    );
  }
}

class _SplashScreenBody extends StatelessWidget {
  const _SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          state.mapOrNull(
            authenticated: (_) {
              Navigator.pushReplacementNamed(context, router.LayoutScreenRoute);
            },
            unauthenticated: (_) {
              Navigator.pushReplacementNamed(
                  context, router.onbordingScreenRoute);
            },
            error: (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.message)),
              );
              Navigator.pushReplacementNamed(context, '/login');
            },
          );
        },
        child: Stack(
          children: [
            // Nền xanh
            Container(color: const Color(0xFF0066FF)),

            // Dot nền mờ
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg_dot.png',
                fit: BoxFit.cover,
              ),
            ),

            // Wave dưới đáy
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Image.asset(
                'assets/images/bg_wave.png',
                fit: BoxFit.cover,
              ),
            ),

            // Logo + Text ở giữa
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 110,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'DVN from Team LC',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Được sáng tạo và phát triển\n'
                    'bởi Đoàn Văn Nghiệp',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SplashCubit, SplashState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
