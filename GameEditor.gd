@tool extends Node

#@export_multiline var moves : String
@export var go : bool = false :
	set(v):
		go = false
		if v: build_animation()
@export var player : AnimationPlayer
@export var pieces : Node
@export var board : Node
@export var animation_name: String

const FOOLS_MATE = [
	[0.5, "P5", "f2", "f3"],
	[0.5, "p4", "e7", "e6"],
	[2.0, "P6", "g2", "g4"],
	[1.0, "q0", "d8", "h4"]]

func get_square(sq:String) -> ColorRect:
	return board.find_child(sq)
	
const MOVE_DUR = 0.5

func sq_pos(sq:String)->Vector2:
	return get_square(sq).global_position

func ensure_track(anim:Animation, trackPath:String) -> int:
	print('ensure track: ', trackPath)
	var found : bool = false
	for i in range(anim.get_track_count()):
		if str(anim.track_get_path(i)) == trackPath:
			return i
	var ix = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(ix, trackPath)
	return ix

func add_move_keyframe(id:String, t:float, p0:Vector2, p1:Vector2):
	var anim = get_animation()
	var track = ensure_track(anim, 'pieces/' + id + ":position")
	anim.track_insert_key(track, t, p0)
	anim.track_insert_key(track, t+MOVE_DUR, p1)

func get_animation()->Animation:
	if not player.has_animation(animation_name):
		push_error("no such animation")
	return player.get_animation(animation_name)
	
func clear_animation():
	var anim = get_animation()
	while anim.get_track_count() > 0:
		anim.remove_track(0)


func build_animation():
	# TODO: parse actual moves into this form
	var game = FOOLS_MATE
	clear_animation()
	print(game)
	var i = 0; var t = 0.0
	for step in game:
		var delay = step[0]; var id = step[1]
		var sq0 = step[2]; var sq1 = step[3]
		var square = get_square(sq0)
		t += delay
		add_move_keyframe(id, t, sq_pos(sq0), sq_pos(sq1))
		t += MOVE_DUR
	get_animation().length = t + 1
	
