extends Node2D
# DepthLimitedAlphaBeta
# DepthLimitedMiniMax

# algorithmMinMax
# algorithmAlphaBeta
var algorithm = null

@export var circle_scene: PackedScene
@export var cross_scene: PackedScene

enum {
	PLAYER = 1,
	AI = -1,
	TIE = 10,
	EMPTY_BOARD = 0
}

var board: Array
var board_size = 600
var move: int
var player: int
var ai: int
var temp_marker
var player_panel_pos: Vector2i
var winner: int
var mouse_position: Vector2i
var board_position: int = -100
var row_sum: int
var col_sum: int
var diagonal1_sum: int
var diagonal2_sum: int

func _ready():
	new_game()
	var choice = get_tree().get_meta("algorithm_choice")
	change_algorithm(choice)
	player_panel_pos = $PlayerPanel.get_position()
	
func change_algorithm(choice):
	match choice:
		1:
			algorithm = preload("res://game/AI/algorithmMinMax.gd").new()
		2:
			algorithm = preload("res://game/AI/algorithmAlphaBeta.gd").new()

# Funkcja wywołuje się w momencie klikniecią, gdy zostanie wciśnięty przycisk MOUSE_BUTTON_LEFT
# pobiera jego kordynaty i następnie zapisuje w planszy
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and event.position.x  < board_size:
		mouse_position = Vector2i(event.position / 200) # zmienna posiada wektory całkowite odpowiadające wciśniętej siatki planszy
		if board[mouse_position.y][mouse_position.x] == 0:
			board_position = board[mouse_position.y][mouse_position.x]
			if winner == 0:
				temp_marker.queue_free()
				take_move()
				create_marker(player_panel_pos + Vector2i(100, 100),true)
			elif winner != 0:
				end_game()

# funkcja tworzy podstawowe parametry gry po włączeniu aplikacji
func new_game():
	board = [[0,0,0],
			[0,0,0],
			[0,0,0]]
	move = PLAYER
	winner = 0
	row_sum = 0
	col_sum = 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	create_marker(player_panel_pos + Vector2i(750, 300),true)
	$GameOverMenu.hide()
	get_tree().paused = false

func end_game():
	if winner == PLAYER:
		get_tree().paused == true
		$GameOverMenu.show()
		$GameOverMenu.get_node("ResultLabel").text = "Gracz wygrał"
	if winner == AI:
		get_tree().paused == true
		$GameOverMenu.show()
		$GameOverMenu.get_node("ResultLabel").text = "AI wygrało"
	if winner == TIE:
		get_tree().paused == true
		$GameOverMenu.show()
		$GameOverMenu.get_node("ResultLabel").text = "Remis"

# funkcja wywołuje funckję player_move lub ai_move zależności jaki jest przypisana wartoś move
func take_move():
	
	if winner == 0:
		if move == PLAYER:
			if(board_position == EMPTY_BOARD) and isMovesLeft() == true:
				player_move(mouse_position * 200 + Vector2i(100, 100))
		if move == AI:
			if isMovesLeft() == true:
				await ai_move()
		create_marker(player_panel_pos + Vector2i(100, 100),true)
	else:
		end_game()

func player_move(position):
	
	var circle = circle_scene.instantiate() # inicjazuje scene circle
	circle.position = position # ustawia scene na pozycji kliknięcią gracza
	add_child(circle) # dodaje scene circle do sceny Board
	board[mouse_position.y][mouse_position.x] = PLAYER
	move *= AI # zmiana kogo ruch
	check_win()


func ai_move():

	await get_tree().create_timer(1).timeout
	var bestMove = algorithm.findBestMove(board) 
	if board[bestMove[0]][bestMove[1]] == EMPTY_BOARD:
		board[bestMove[0]][bestMove[1]] = AI
		var grid_pos_com = Vector2i(bestMove[1],bestMove[0])
		var position1 = grid_pos_com * 200 + Vector2i(100, 100)
		var cross = cross_scene.instantiate()
		cross.position = position1
		add_child(cross)
		temp_marker.queue_free()
		move *= AI
	check_win()

# Funkcja sprawdza czy ktoś wygrał na planszy przypisje zmiennej winner konretną wartośc zalęzności od warunków
func check_win():
	if isMovesLeft() == false:
		winner = TIE
		end_game()
	for i in len(board):
		row_sum = board[i][0] + board[i][1] + board[i][2]
		col_sum = board[0][i] + board[1][i] + board[2][i]
		diagonal1_sum = board[0][0] + board[1][1] + board[2][2]
		diagonal2_sum = board[0][2] + board[1][1] + board[2][0]
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = PLAYER
			end_game()
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = AI
			end_game()

# Funckja sprawdza czy pozostały jakiekolwiek ruchy
func isMovesLeft():  
	for i in range(3) : 
		for j in range(3) : 
			if (board[i][j] == EMPTY_BOARD) : 
				return true
	return false

func create_marker(position, temp = false):
	if move == PLAYER:
		var circle = circle_scene.instantiate() # inicjazuje scene circle
		circle.position = position # ustawia scene na pozycji kliknięcią gracza
		add_child(circle) # dodaje scene circle do sceny Board
		if temp:
			temp_marker = circle
	if move == AI:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp:
			temp_marker = cross


func _on_game_over_menu_restart():
	new_game()
	$GameOverMenu.hide()
