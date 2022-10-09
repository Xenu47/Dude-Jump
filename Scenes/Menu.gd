extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Globals = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Globals.change_font_color_hsv($Label.get_font("font"))
	Globals.change_font_color_hsv($Button.get_font("font"))
	Globals.animate_label($Label)
	Globals.move_tiles(get_node("../TileMap"))
	animate_sprite($Sprite)
	pass

#func move_tiles(tile):
#	tile.position.y += 2
#	pass

#func animate_label(label):
#	var k = 2
#	var rot = 8*(fmod(time, k)-k/2)
#	if fmod(time, 2*k) >= k:
#		rot *= -1
#	label.rect_rotation = rot
#	pass

func animate_sprite(sprite):
	var stretch = fmod(Globals.time, 1)
	var flip = fmod(Globals.time, 2)
	if flip > 1.5:
		flip = 4*(1.75 - flip)
		sprite.scale.x = pow(-1, int(fmod(Globals.time, 4)/2)) * 5.333*(flip)
	if stretch >= 0.5:
		stretch = 1 - stretch
	stretch += 0.75
	sprite.scale.y = 5.333*(stretch)
	sprite.position.y = 448 - 24*5.333*(stretch-1)
	pass

#func change_logo_color_hsv(font):
#	font.outline_color = Color.from_hsv(fmod(time,2), 1, 1, 1)
#	pass


#func change_logo_color_rgb():
#	var font = get_node("Label").get_font("font")
#	var r = fmod(time+4,6)
#	var g = fmod(time+2,6)
#	var b = fmod(time,6)
#	if r > 3:
#		r = 1-(r-3)
#		if r > 1:
#			r = 0
#	if g > 3:
#		g = 1-(g-3)
#		if g > 1:
#			g = 0
#	if b > 3:
#		b = 1-(b-3)
#		if b > 1:
#			b = 0
#	font.outline_color = Color(r, g, b, 1)
#	pass

