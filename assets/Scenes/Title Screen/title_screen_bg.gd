extends Parallax2D

var bg_height
var bg_tiles = []

var bg_count = 4

func _ready():
	var base2 = $base2
	
	var base2H = base2.texture.get_height() - 390

	bg_tiles.append(base2)

	# generate bg tiles upward
	for i in range(1, bg_count):

		var t = base2.duplicate()
		t.position = base2.position
		t.position.y += base2H * i

		add_child(t)
		bg_tiles.append(t)
		
