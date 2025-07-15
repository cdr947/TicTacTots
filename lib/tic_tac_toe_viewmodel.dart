import 'package:flutter/material.dart';

class TicTacToeViewModel extends ChangeNotifier {
  List<int>? winningLine;
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;
  String winner = '';
  bool showConfetti = false;
  String endMessage = '';
  final bool isVsAI;

  TicTacToeViewModel({required this.isVsAI});

  void resetGame() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    gameOver = false;
    winner = '';
    showConfetti = false;
    endMessage = '';
    winningLine = null;
    notifyListeners();
  }

  void makeMove(int index) {
    if (board[index] == '' && !gameOver) {
      board[index] = currentPlayer;
      checkWinner();
      if (!gameOver) {
        if (isVsAI && currentPlayer == 'X') {
          currentPlayer = 'O';
          notifyListeners();
          Future.delayed(Duration(milliseconds: 500), () {
            aiMove();
          });
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }
  }

  void aiMove() {
    // Minimax AI for Tic Tac Toe
    int bestScore = -9999;
    int? bestMove;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = minimax(board, 0, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    if (bestMove != null) {
      board[bestMove] = 'O';
      checkWinner();
      if (!gameOver) currentPlayer = 'X';
      notifyListeners();
    }
  }

  int minimax(List<String> boardState, int depth, bool isMaximizing) {
    // Terminal state check
    if (_checkWinnerFor('O', boardState)) {
      return 1;
    } else if (_checkWinnerFor('X', boardState)) {
      return -1;
    } else if (!boardState.contains('')) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -9999;
      for (int i = 0; i < 9; i++) {
        if (boardState[i] == '') {
          boardState[i] = 'O';
          int score = minimax(boardState, depth + 1, false);
          boardState[i] = '';
          if (score > bestScore) bestScore = score;
        }
      }
      return bestScore;
    } else {
      int bestScore = 9999;
      for (int i = 0; i < 9; i++) {
        if (boardState[i] == '') {
          boardState[i] = 'X';
          int score = minimax(boardState, depth + 1, true);
          boardState[i] = '';
          if (score < bestScore) bestScore = score;
        }
      }
      return bestScore;
    }
  }

  bool _checkWinnerFor(String player, List<String> boardState) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      if (boardState[pattern[0]] == player &&
          boardState[pattern[1]] == player &&
          boardState[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      String a = board[pattern[0]];
      String b = board[pattern[1]];
      String c = board[pattern[2]];
      if (a != '' && a == b && b == c) {
        gameOver = true;
        winner = a;
        showConfetti = true;
        endMessage = a == 'X' ? '🎉 X Wins! 🎉' : '🎉 O Wins! 🎉';
        winningLine = pattern;
        return;
      }
    }
    winningLine = null;
    if (!board.contains('')) {
      gameOver = true;
      winner = 'Draw';
      showConfetti = true;
      endMessage = "It's a Draw!";
    }
  }
}
