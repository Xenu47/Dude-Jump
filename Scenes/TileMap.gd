extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lines_lost = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var y_amount = ceil(get_viewport_rect().size.y / self.cell_size.y)+4
	var x_amount = ceil(get_viewport_rect().size.x / self.cell_size.x)*2 + 2
	for i in range(y_amount):
		var x
		var y
		for j in range(x_amount):
			x = 192 * 0.5*j
			y = 192 * (i + 0.5*fmod(j+1, 2)) - 192*2
			var cell = world_to_map(Vector2(x,y))
			var flip_x = bool(randi() % 2)
			var flip_y = bool(randi() % 2)
			var transpose = bool(randi() % 2)
			self.set_cellv(cell, 0, flip_x, flip_y, transpose)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var k = int(self.position.y / 192)
	if k != lines_lost:
		for i in range(k - lines_lost):
			lines_lost += 1
			spawn_new_tiles()
			remove_old_tiles()
	pass

func spawn_new_tiles():
	var y_amount = 1
	var x_amount = ceil(get_viewport_rect().size.x / self.cell_size.x)*2 + 2
	for i in range(y_amount):
		var x
		var y
		for j in range(x_amount):
			x = 192 * 0.5*j
			y = 192 * (i + 0.5*fmod(j+1, 2)) - 192*2 - 192*lines_lost
			var cell = world_to_map(Vector2(x,y))
			var flip_x = bool(randi() % 2)
			var flip_y = bool(randi() % 2)
			var transpose = bool(randi() % 2)
			self.set_cellv(cell, 0, flip_x, flip_y, transpose)
	pass

func remove_old_tiles():
	var y_amount = 1
	var x_amount = ceil(get_viewport_rect().size.x / self.cell_size.x)*2 + 2
	for i in range(y_amount):
		var x
		var y
		for j in range(x_amount):
			x = 192 * 0.5*j
			y = 192 * (i + 0.5*fmod(j+1, 2)) - 192*2 - 192*lines_lost + 192*(ceil(get_viewport_rect().size.y / self.cell_size.y)+4)
			var cell = world_to_map(Vector2(x,y))
			var flip_x = bool(randi() % 2)
			var flip_y = bool(randi() % 2)
			var transpose = bool(randi() % 2)
			self.set_cellv(cell, -1, flip_x, flip_y, transpose)
	pass
