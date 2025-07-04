extends Node

var search: int

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

# funckaj szuka we wszystkich możliwych ruchach najlepszy ruch dla AI 
# wywołuje Minimax która jest wykonywana rekurencyjnie dpóki nie znajdzie liścia
func findBestMove(board, targetDepth):
	var curDepth = 0
	var bestScore = 100000
	var bestMove = Vector2i(100,100)
	for i in range(3):
		for j in range(3):
			if (board[i][j] == 0):
				board[i][j] = -1
				var score = Minimax(board, curDepth, targetDepth, false)
				board[i][j] = 0
				if (score < bestScore):
					bestScore = score
					bestMove = Vector2i(i,j)
	print(search)
	return bestMove


func Minimax(board, curDepth, targetDepth, isMax):
	var result = evaluate(board)
	# Zwraca wartość liścia lub gdy osiągnie konretną głębokość
	if targetDepth == 0 or result == 1 or result == -1 or isMovesLeft(board) == false:
		search += 1
		return result
	
	if targetDepth > 0:
		targetDepth -= 1
		# Ruch MAX
		if(isMax):
			var bestScore = -1000
			for i in range(3):
				for j in range(3):
					if (board[i][j] == 0):
						board[i][j] = -1
						var score = Minimax(board, curDepth + 1,targetDepth, false)
						board[i][j] = 0
						bestScore = max(score, bestScore) # wybiera Max z dzieci
			return bestScore
		# Ruch MIN
		else:
			var bestScore = 1000
			for i in range(3):
				for j in range(3):
					if (board[i][j] == 0):
						board[i][j] = 1
						var score = Minimax(board, curDepth + 1,targetDepth , true)
						board[i][j] = 0
						bestScore = min(score, bestScore) # wybiera Min z dzieci
			return bestScore
