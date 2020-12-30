extends Node

var rng = RandomNumberGenerator.new()

var cards: Array = ["a", "b", "c", "d"]
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
var connections: Dictionary = {}
var board_state: Dictionary = {}
var game_state: Array = []


func _init():
	rng.randomize()
	new_game()


func new_game() -> void:
	generate_cards()
	generate_board()
	print(board_state)


func generate_cards() -> void:
	for i in range(4):
		var card_type = cards[i]
		var card = card_type
		for _j in range(3):
			card += card_type
			cards.append(card)


func generate_board() -> void:
	for i in range(16):
		game_state.append(0)
		var rand: int = rand_range(0, len(cards) - 1)
		var card: String = cards[rand]
		var suit: String = card[0]
		var value: int = len(card)
		
		if not connections.has(suit):
			connections[suit]= []
		connections[suit].append(i)
		if not connections.has(value):
			connections[value] = []
		connections[value].append(i)
		
		board_state[i] = {
			"card": card,
			"cxns": [],
			"valid": true
		}
		
		cards.erase(card)
	fill_connections()


func fill_connections() -> void:
	for pos in board_state:
		var info: Dictionary = board_state[pos]
		var card: String = info.card
		var suit: String = card[0]
		var value: int = len(card)
		
		info.cxns += connections[suit]
		info.cxns += connections[value]
		
		while info.cxns.has(pos):
			info.cxns.erase(pos)


func update_pos(pos: int, player: int) -> void:
	remove_card(pos)
	for score in scoring[pos]:
		game_state[score] += player
		check_for_win(game_state[score])


func remove_card(pos: int) -> void:
	var info: Dictionary = board_state[pos]
	remove_connections(info.cxns, pos)
	info.valid = false


func remove_connections(cxns: Array, pos: int) -> void:
	for cxn in cxns:
		board_state[cxn].cxns.erase(pos)


func check_for_win(value: int) -> void:
	if abs(value) == 4:
		initiate_game_end(value)


func initiate_game_end(winner: int) -> void:
	pass
