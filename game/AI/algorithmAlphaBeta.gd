extends Node

enum {
	PLAYER = 1,
	AI = -1,
	WIN = 10,
	LOSE = -10
}
# Funkcja zwraca czy pozostał ruch na planszy
# Zwraca true gdy jest możliwy false w przeciwnym razie
func isMovesLeft(board):  
	for i in range(3) : 
		for j in range(3) : 
			if (board[i][j] == 0) : 
				return true
	return false

func evaluate(board):
	# Sprawdzanie wierszy i kolumn
	for i in range(3):
		if board[i][0] + board[i][1] + board[i][2] == 3:
			return LOSE
		if board[i][0] + board[i][1] + board[i][2] == -3:
			return WIN
		if board[0][i] + board[1][i] + board[2][i] == 3:
			return LOSE
		if board[0][i] + board[1][i] + board[2][i] == -3:
			return WIN
	# Sprawdzanie przekątnych
	if board[0][0] + board[1][1] + board[2][2] == 3 or board[0][2] + board[1][1] + board[2][0] == 3:
		return LOSE
	if board[0][0] + board[1][1] + board[2][2] == -3 or board[0][2] + board[1][1] + board[2][0] == -3:
		return WIN
	return 0


# funckaj szuka we wszystkich możliwych ruchach najlepszy ruch dla AI 
# wywołuje Minimax która jest wykonywana rekurencyjnie dpóki nie znajdzie liścia
func findBestMove(board):
	var bestScore = -1000
	var bestMove = Vector2i(-100,-100)
	for i in range(3):
		for j in range(3):
			if (board[i][j] == 0):
				board[i][j] = AI
				var score = AlphaBeta(board, 0,-1000,1000, false)
				board[i][j] = 0
				if (score > bestScore):
					bestScore = score
					bestMove = Vector2i(i,j)
	return bestMove

func AlphaBeta(board, depth,alpha, beta, isMax):
	var result = evaluate(board)
	# Jezeli jest to lisc, zwraca wynik
	if result == WIN:
		return result - depth # szybsze zwyciestwa
	if result == LOSE:
		return result + depth # dluzsze porazki
	if not isMovesLeft(board):
		return 0

	# Ruch MAX
	if(isMax):
		var bestScore = -1000
		for i in range(3):
			for j in range(3):
				if (board[i][j] == 0):
					board[i][j] = AI 
					var score = AlphaBeta(board, depth + 1,-1000,1000, false)
					board[i][j] = 0
					bestScore = max(score, bestScore) # wybiera max z dzieci
					alpha = max(alpha, bestScore)
					if beta <= alpha:
						break
		return bestScore
	# Ruch MIN
	else:
		var bestScore = 1000
		for i in range(3):
			for j in range(3):
				if (board[i][j] == 0):
					board[i][j] = PLAYER
					var score = AlphaBeta(board, depth + 1,-1000,1000, true)
					board[i][j] = 0
					bestScore = min(score, bestScore) # wybiera min z dzieci
					beta = min(beta, bestScore)
					if beta <= alpha:
						break
		return bestScore
