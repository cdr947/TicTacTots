import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../confetti_widget.dart';
import '../tic_tac_toe_viewmodel.dart';

class TicTacToeScreen extends StatelessWidget {
  final bool isVsAI;
  const TicTacToeScreen({super.key, required this.isVsAI});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TicTacToeViewModel(isVsAI: isVsAI),
      child: const TicTacToeView(),
    );
  }
}

class TicTacToeView extends StatefulWidget {
  const TicTacToeView({super.key});

  @override
  State<TicTacToeView> createState() => _TicTacToeViewState();
}

class _TicTacToeViewState extends State<TicTacToeView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _turnController;
  late Animation<double> _turnAnimation;
  late final Widget xAvatarWidget;
  late final Widget oAvatarWidget;
  late final String xLabel;
  late final String oLabel;

  @override
  void initState() {
    super.initState();
    // Choose avatars and labels based on game mode
    final vm = Provider.of<TicTacToeViewModel>(context, listen: false);
    final bool vsAI = vm.isVsAI;
    if (vsAI) {
      // Player vs AI: Player = human SVG, AI = cyborg PNG
      xAvatarWidget = Image.asset('assets/Kid.png', width: 48, height: 48);
      oAvatarWidget = Image.asset('assets/AI.png', width: 48, height: 48);
      xLabel = 'You';
      oLabel = 'AI';
    } else {
      // Player vs Player: human vs devil SVG
      xAvatarWidget = Image.asset('assets/Men.png', width: 48, height: 48);
      oAvatarWidget = Image.asset('assets/Devil.png', width: 48, height: 48);
      xLabel = 'Player 1 (X)';
      oLabel = 'Player 2 ("O")';
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    _turnController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _turnAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _turnController, curve: Curves.easeInOut),
    );
    _turnController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _turnController.dispose();
    super.dispose();
  }

  Color getCellColor(String value) {
    if (value == 'X') return Colors.orangeAccent;
    if (value == 'O') return Colors.lightBlueAccent;
    return Colors.white;
  }

  Widget buildCell(
    int index,
    TicTacToeViewModel vm,
    double cellSize,
    double fontSize,
  ) {
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTap: () => vm.makeMove(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: getCellColor(vm.board[index]),
            borderRadius: BorderRadius.circular(cellSize * 0.18),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.deepPurple, width: 3),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Text(
                vm.board[index],
                key: ValueKey(vm.board[index]),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color:
                      vm.board[index] == 'X' ? Colors.deepOrange : Colors.blue,
                  shadows: [
                    const Shadow(
                      blurRadius: 8,
                      color: Colors.yellowAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<TicTacToeViewModel>(
  //     builder: (context, vm, child) {
  //       return Scaffold(
  //         backgroundColor: Colors.white,
  //         appBar: PreferredSize(
  //           preferredSize: const Size.fromHeight(70),
  //           child: AppBar(
  //             backgroundColor: Colors.white,
  //             elevation: 0,
  //             centerTitle: true,
  //             title: Text(
  //               'Tic Tac Toe',
  //               style: TextStyle(
  //                 color: Colors.purple[700],
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 26,
  //                 letterSpacing: 1.2,
  //                 fontFamily: 'Poppins',
  //               ),
  //             ),
  //             leading: IconButton(
  //               icon: Icon(Icons.arrow_back, color: Colors.purple[400]),
  //               onPressed: () => Navigator.of(context).pop(),
  //               tooltip: 'Back',
  //             ),
  //             actions: [
  //               IconButton(
  //                 icon: Icon(Icons.refresh, color: Colors.purple[400]),
  //                 onPressed: vm.resetGame,
  //                 tooltip: 'Restart',
  //               ),
  //             ],
  //             shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.vertical(
  //                 bottom: Radius.circular(24),
  //               ),
  //             ),
  //           ),
  //         ),
  //         body: Stack(
  //           children: [
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
  //                   child: Row(
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isPortrait = media.orientation == Orientation.portrait;
    // Responsive cell size and font size for grid
    final gridPadding = screenWidth * 0.04;
    final cellSize = (screenWidth - gridPadding * 2 - 18 * 2) / 3;
    final cellFontSize = cellSize * 0.7;
    // Responsive avatar size
    final avatarSize = screenWidth * 0.13;
    return Consumer<TicTacToeViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.09),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Tic Tac Toe',
                style: TextStyle(
                  color: Colors.purple[700],
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06,
                  letterSpacing: 1.2,
                  fontFamily: 'Poppins',
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.purple[400]),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back',
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.purple[400]),
                  onPressed: vm.resetGame,
                  tooltip: 'Restart',
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            AnimatedScale(
                              scale: vm.currentPlayer == 'X' ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 400),
                              child: SizedBox(
                                width: avatarSize,
                                height: avatarSize,
                                child: xAvatarWidget,
                              ),
                            ),
                            Text(
                              xLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            AnimatedScale(
                              scale: vm.currentPlayer == 'O' ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 400),
                              child: SizedBox(
                                width: avatarSize,
                                height: avatarSize,
                                child: oAvatarWidget,
                              ),
                            ),
                            Text(
                              oLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                    child: AnimatedBuilder(
                      animation: _turnAnimation,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Opacity(
                              opacity: vm.currentPlayer == 'X' ? 1.0 : 0.3,
                              child: Container(
                                width: screenWidth * 0.15,
                                height: screenHeight * 0.012,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: .4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: vm.currentPlayer == 'O' ? 1.0 : 0.3,
                              child: Container(
                                width: screenWidth * 0.15,
                                height: screenHeight * 0.012,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepOrange.withValues(
                                        alpha: .4,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.015,
                      bottom: screenHeight * 0.01,
                    ),
                    child: Text(
                      vm.gameOver
                          ? (vm.winner == 'Draw'
                              ? "It's a Draw!"
                              : (vm.winner == 'X' ? "Blue Wins!" : "Red Wins!"))
                          : (vm.currentPlayer == 'X' ? "X's Turn" : "O's Turn"),
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color:
                            vm.gameOver
                                ? (vm.winner == 'X'
                                    ? Colors.lightBlue[400]
                                    : vm.winner == 'O'
                                    ? Colors.red[300]
                                    : Colors.deepPurple)
                                : (vm.currentPlayer == 'X'
                                    ? Colors.lightBlue[400]
                                    : Colors.red[300]),
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.grey.withValues(alpha: .12),
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: gridPadding,
                        vertical: screenHeight * 0.01,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.07,
                          ),
                          border: Border.all(
                            color: Colors.purple[100]!,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: .07),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: GridView.builder(
                          padding: EdgeInsets.all(gridPadding),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: gridPadding,
                                mainAxisSpacing: gridPadding,
                                childAspectRatio: 1,
                              ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return buildCell(index, vm, cellSize, cellFontSize);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
              if (vm.showConfetti) ConfettiWidget(show: vm.showConfetti),
              if (vm.gameOver && vm.endMessage.isNotEmpty)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: .5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            vm.endMessage,
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.yellowAccent,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Play Again',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.022,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          screenWidth * 0.04,
                                        ),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: vm.resetGame,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.black87,
                                    ),
                                    label: Text(
                                      'Go Back',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.018,
                                      ),
                                      side: const BorderSide(
                                        color: Colors.black26,
                                        width: 1.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          screenWidth * 0.04,
                                        ),
                                      ),
                                    ),
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
