import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/logo_button.dart';
import '../widgets/animated_text.dart';
import '../widgets/game_mode_button.dart';
import '../tic_tac_toe_viewmodel.dart';
import 'tic_tac_toe_screen.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 160,
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(child: SvgPicture.asset('assets/logo.svg')),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoButton(
                    asset: 'assets/archenemy_2453858.png',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder:
                              (context, anim1, anim2) => FadeTransition(
                                opacity: anim1,
                                child: TicTacToeScreen(isVsAI: false),
                              ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 32),
                  LogoButton(
                    asset: 'assets/cyborg_4057275.png',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder:
                              (context, anim1, anim2) => FadeTransition(
                                opacity: anim1,
                                child: TicTacToeScreen(isVsAI: true),
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
