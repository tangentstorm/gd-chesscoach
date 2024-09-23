@tool extends Panel

@export var go : bool = false :
	set(v):
		if v: do_something()
		go = false

func do_something():
	organize()
	
func organize():
	print("organizing ", name, '...')
	var i = 0
	var cols = 8
	var gap_size = 2
	var cell_size = 48
	for child in get_children():
		var x = (i % cols) * (cell_size + gap_size)
		var y = floor(i/cols) * (cell_size + gap_size)
		y -= 6 # just for looks
		child.position = Vector2(x, y)
		i += 1
	print('organized ', i, ' children.')
