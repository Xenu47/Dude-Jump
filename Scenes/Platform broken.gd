extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("player_collided", false)
	self.set_meta("broken", true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $AnimatedSprite.frame +1 == $AnimatedSprite.frames.get_frame_count("default"):
		$AnimatedSprite.playing = false
	pass
