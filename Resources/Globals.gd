extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var retry = false
var time = 0
var score = 0
var highscore = score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_rocess(delta):
#	time += delta
	pass

func change_font_color_hsv(font):
	font.outline_color = Color.from_hsv(fmod(time,2), 1, 1, 1)
	pass

func animate_label(label):
	var k = 2
	var rot = 8*(fmod(time, k)-k/2)
	if fmod(time, 2*k) >= k:
		rot *= -1
	label.rect_rotation = rot
	pass

func move_tiles(tile):
	tile.position.y += 1
	pass


func save():
	var save_dict = {
		"highscore" : int(highscore)
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var node_data = self.call("save")
	print(node_data)
	save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		for i in node_data.keys():
			self.set(i, node_data[i])
	save_game.close()
