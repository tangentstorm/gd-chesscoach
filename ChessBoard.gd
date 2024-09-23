@tool extends Panel
@export var go : bool = false :
	set(v):
		if v: do_something()
		go = false
@export var clear : bool = false :
	set(v):
		if v: clear_board()
		clear = false
@export var plies : Array[String]

@export var blackTray : Node2D
@export var whiteTray : Node2D

const INIT_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
const FILES="abcdefgh"

# const GAME_FEN = "3q1rk1/pBr2ppp/Q4n2/2N5/2p3b1/4P1P1/PP3P1P/R1Bq1RK1 w - - 0 18"
const GAME_FEN = "3q1rk1/pBr2ppp/Q4n2/2N5/2p3b1/4P1P1/PP1p1P1P/R1B2RK1 b - - 0 17"

func do_something():
	setup_board(INIT_FEN)

func setup_board(fen:String):
	clear_board()
	var seen = {}; for each in "rnbqkpRNBQKP": seen[each]=0
	var y = 8
	for row in fen.split(' ')[0].split('/'):
		var x = 0
		for c in row:
			if c > '0' and c < '9': x += int(c)
			else: # TODO: check that c is in seen (else invalid FEN)
				var tray = blackTray if c > 'Z' else whiteTray
				var piece : Sprite2D = tray.get_node(c + str(seen[c]))
				seen[c] += 1
				var square : ColorRect = get_node('ranks/rank'+str(y)+'/'+FILES[x]+str(y))
				piece.reparent($pieces)
				piece.global_position = square.global_position
				x += 1
		y -= 1
	organize_trays()

func clear_board():
	for piece in get_node("pieces").get_children():
		var c = str(piece.name)[0]
		var tray = blackTray if c > 'Z' else whiteTray
		piece.reparent(tray)
	organize_trays()

func organize_trays():
	blackTray.organize()
	whiteTray.organize()
