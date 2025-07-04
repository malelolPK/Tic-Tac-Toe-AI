extends Node


# funkcja zwraca wartość wartość liścia
func evaluate(board):
	for i in len(board):
		var row_sum_e = board[i][0] + board[i][1] + board[i][2]
		var col_sum_e = board[0][i] + board[1][i] + board[2][i]
		var diagonal1_sum_e = board[0][0] + board[1][1] + board[2][2]
		var diagonal2_sum_e = board[0][2] + board[1][1] + board[2][0]
		if row_sum_e == 3 or col_sum_e == 3 or diagonal1_sum_e == 3 or diagonal2_sum_e == 3:
			return 1
		elif row_sum_e == -3 or col_sum_e == -3 or diagonal1_sum_e == -3 or diagonal2_sum_e == -3:
			return -1
	return 0

# Funkcja zwraca czy pozostał ruch na planszy
# Zwraca true gdy jest możliwy false w przeciwnym razie
func isMovesLeft(board):  
	for i in range(3) : 
		for j in range(3) : 
			if (board[i][j] == 0) : 
				return true
	return false

func findBestMove(board, targetDepth):
	var curDepth = 0
	var bestScore = 100000
	var bestMove = Vector2i(100,100)
	for i in range(3):
		for j in range(3):
			if (board[i][j] == 0):
				board[i][j] = -1
				var score = AlphaBeta(board,curDepth, targetDepth,-1000,1000, false)
				board[i][j] = 0
				if (score < bestScore):
					bestScore = score
					bestMove = Vector2i(i,j)
	return bestMove

func AlphaBeta(board, curDepth, targetDepth,alpha, beta, isMax):
	var result = evaluate(board)
	if targetDepth == 0 or result == 1 or result == -1 or isMovesLeft(board) == false:
		return result
		
	
	if targetDepth > 0:
		targetDepth -= 1
		if(isMax):
			var bestScore = -1000
			for i in range(3):
				for j in range(3):
					if (board[i][j] == 0):
						board[i][j] = -1
						var score = AlphaBeta(board, curDepth + 1, targetDepth,alpha, beta, false)
						board[i][j] = 0
						bestScore = max(score, bestScore)
						alpha = max(alpha, score)
						if beta <= alpha:
							break
			return bestScore
			
		else:
			var bestScore = 1000
			for i in range(3):
				for j in range(3):
					if (board[i][j] == 0):
						board[i][j] = 1
						var score = AlphaBeta(board,  curDepth + 1, targetDepth,alpha, beta, true) # po min turze jest max tura dlatego true
						board[i][j] = 0
						bestScore = min(score, bestScore)
						beta = min(beta, score)
						if beta <= alpha:
							break
			return bestScore
