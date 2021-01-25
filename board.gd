extends Node2D


var Space = preload("res://space.tscn")


var rng = RandomNumberGenerator.new()
var scoring: Dictionary = {
	0: [0, 5, 9, 10],
	1: [1, 5, 10, 11],
	2: [2, 5, 11, 12],
	3: [3, 4, 5, 12],
	4: [0, 6, 10, 13],
	5: [1, 6, 9, 10, 11, 13, 14],
	6: [2, 4, 6, 11, 12, 14, 15],
	7: [3, 6, 12, 15],
	8: [0, 7, 13, 16],
	9: [1, 4, 7, 13, 14, 16, 17],
	10: [2, 7, 9, 14, 15, 17, 18],
	11: [3, 7, 15, 18],
	12: [0, 4, 8, 16],
	13: [1, 8, 16, 17],
	14: [2, 8, 17, 18],
	15: [3, 8, 9, 18]
}
var cards: Array = ["a", "b", "c", "d"]
var connections: Dictionary = {}
var board_state: Dictionary = {}
var game_state: Array = []
var turn: int = 1
var current_player: int = 1
var current_card = null
var legal_moves: Array = []
var spaces = []


func _ready():
	new_game()


func new_game() -> void:
	generate_cards()
	generate_board()
	set_legal_moves()


func update_pos(pos: int) -> void:
	remove_card(pos)
	unhighlight_spaces(pos)
	spaces[pos].show_coin(current_player)
	if turn > 1:
		spaces[current_card.pos].hide_turn()
	current_card = board_state[pos]
	$CurrentCard.init(current_card.card, 0)
	$CurrentCard.show()
	turn += 1
	set_legal_moves()
	for score in scoring[pos]:
		game_state[score] += current_player
		if check_for_win(game_state[score]):
			return
	current_player = current_player * -1
	


func generate_cards() -> void:
	for i in range(4):
		var card_type = cards[i]
		var card = card_type
		for _j in range(3):
			card += card_type
			cards.append(card)


func generate_board() -> void:
	while len(game_state) < 19:
		game_state.append(0)
	for i in range(16):
		var rand: int = rng.randi_range(0, len(cards) - 1)
		var card: String = cards[rand]
		var suit: String = card[0]
		var value: int = len(card)
		
		set_connection(suit, value, i)
		
		board_state[i] = {
			"card": card,
			"cxns": [],
			"pos": i
		}
		var space = Space.instance()
		space.init(card, i)
		space.connect("enter_hover", self, "highlight_spaces")
		space.connect("leave_hover", self, "unhighlight_spaces")
		space.connect("make_move", self, "update_pos")
		spaces.append(space)
		$CenterContainer/GridContainer.add_child(space)
		
		cards.erase(card)
	add_connections_to_board_state()


func set_connection(suit: String, value: int, i: int) -> void:
	if not connections.has(suit):
		connections[suit]= []
	connections[suit].append(i)
	if not connections.has(value):
		connections[value] = []
	connections[value].append(i)


func add_connections_to_board_state() -> void:
	for pos in board_state:
		var info: Dictionary = board_state[pos]
		var card: String = info.card
		var suit: String = card[0]
		var value: int = len(card)
		
		info.cxns += connections[suit]
		info.cxns += connections[value]
		
		while info.cxns.has(pos):
			info.cxns.erase(pos)


func remove_card(pos: int) -> void:
	var info: Dictionary = board_state[pos]
	remove_connections(info.cxns, pos)


func remove_connections(cxns: Array, pos: int) -> void:
	for cxn in cxns:
		board_state[cxn].cxns.erase(pos)


func set_legal_moves() -> void:
	if turn == 1:
		legal_moves = board_state.keys()
		return
	legal_moves = current_card.cxns
	update_legal_spaces()


func disable_illegal_spaces() -> void:
	for i in range(len(spaces)):
		if not legal_moves.has(i):
			spaces[i].become_illegal()


func enable_legal_spaces() -> void:
	for i in legal_moves:
		spaces[i].become_legal()


func update_legal_spaces() -> void:
	disable_illegal_spaces()
	enable_legal_spaces()


func check_for_win(value: int) -> bool:
	if abs(value) == 4:
		initiate_game_end(sign(value))
		return true
	elif legal_moves.empty():
		initiate_game_end(current_player)
		return true
	return false


func initiate_game_end(winner: int) -> void:
	if winner == 1:
		print("Player 1 wins!")
	elif winner == -1:
		print("Player 2 wins!")


func highlight_spaces(pos) -> void:
	var cxns: Array = board_state[pos].cxns
	for cxn in cxns:
		spaces[cxn].start_highlight()


func unhighlight_spaces(pos) -> void:
	spaces[pos].end_hover()
	var cxns: Array = board_state[pos].cxns
	for cxn in cxns:
		spaces[cxn].end_highlight()


func _on_Button_pressed():
	get_tree().paused = true
	$Pause.show()
