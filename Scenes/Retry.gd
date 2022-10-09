extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_highscore = false


# Called when the node enters the scene tree for the first time.
func _ready():
	new_highscore = Globals.highscore == Globals.score
	if new_highscore:
		$Label.text = "NEW HIGHSCORE🤑🤑🤑🤑🤑\n"+str(int(Globals.score))
	else:
		$Label.get_font("font").outline_color = Color("952323")
		$Label.text = "Score:\n"+str(int(Globals.score))+"\n\n"+str(int(Globals.highscore-Globals.score))+"\nto new best!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if new_highscore:
		Globals.animate_label($Label)
		Globals.change_font_color_hsv($Label.get_font("font"))
	Globals.move_tiles(get_parent().get_node("TileMap"))
	Globals.change_font_color_hsv($Button.get_font("font"))
	Globals.change_font_color_hsv($Button2.get_font("font"))
	pass
