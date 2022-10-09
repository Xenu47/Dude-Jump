extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var run_speed = 400
export (int) var jump_speed = -1400 # -2000 - max, unstable!
export (int) var max_allowed_height = 300
#var gravity = 400
var gravity = pow(jump_speed, 2)/(2*max_allowed_height)

var velocity = Vector2()
var jumping = false

var anim_frames = 10
var anim_frames_current = anim_frames
var max_shrink = 0.25

var collision

# Called when the node enters the scene tree for the first time.
func _ready():
	var s1 = $Sprite.duplicate()
	var c1 = $CollisionPolygon2D.duplicate()
	var s2 = $Sprite.duplicate()
	var c2 = $CollisionPolygon2D.duplicate()
	self.add_child(s1)
	self.add_child(c1)
	self.add_child(s2)
	self.add_child(c2)
	s1.position.x = get_viewport_rect().size.x / self.scale.x
	c1.position.x = s1.position.x
	s2.position.x = -get_viewport_rect().size.x / self.scale.x
	c2.position.x = s2.position.x
	s1.add_to_group("Player Sprites")
	s2.add_to_group("Player Sprites")
	$Sprite.add_to_group("Player Sprites")
	
	pass # Replace with function body.


#var vel_sign = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	movement_loop()
	
#	print("p=", self.position.y, " v=", self.velocity.y)
	velocity.y += gravity * delta
#	if sign(velocity.y) != vel_sign:
#		vel_sign = sign(velocity.y)
##		print("pos = ", self.position.y)
	jump()
#	valocity = self.move_and_slide(velocity, Vector2(0, -1))
	self.move_and_slide(velocity, Vector2(0, -1))
	
	screen_borders()
	
	if self.global_position.y > get_viewport_rect().size.y + 4*48:
		get_parent().get_parent().game_over()
	pass

func screen_borders():
#	print(self.position)
	if self.position.x > get_viewport_rect().size.x:
		self.position.x = 0
	if self.position.x < 0:
		self.position.x = get_viewport_rect().size.x
	pass

func movement_loop():
#	velocity = Vector2()
	velocity.x = 0
	velocity.x = (int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))) * run_speed
#	velocity.y = (int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up")))
#	velocity = velocity.normalized() * speed
#	var jump = Input.is_action_just_pressed('Up')
#
#	if jump and is_on_floor():
#		jumping = true
#		velocity.y = jump_speed
	
	
	if (((Input.is_action_pressed("Right") and $Sprite.flip_h)
		or (Input.is_action_pressed("Left") and not $Sprite.flip_h))
		and not (Input.is_action_pressed("Left") and Input.is_action_pressed("Right"))):
			for s in get_tree().get_nodes_in_group("Player Sprites"):
				s.flip_h = not s.flip_h
	pass

func jump():
	if is_on_floor():
#	if is_on_floor() and velocity.y>0:
		anim_frames_current = 0
		jumping = true
		velocity.y = jump_speed
		for i in get_slide_count():
#			if collision != null:
#				if collision.collider == get_slide_collision(i).collider:
#					print(1)
#					self.global_position.y = get_slide_collision(i).collider.global_position.y
			collision = get_slide_collision(i)
			if collision.collider.get_meta("broken"):
				collision.collider.get_node("CollisionPolygon2D").polygon = []
				collision.collider.get_node("AnimatedSprite").playing = true
			else:
				collision.collider.set_meta("player_collided", true)
	if jumping and is_on_floor():
		jumping = false
	if anim_frames_current < anim_frames:
		anim_frames_current += 1
		var k = 4
		if anim_frames_current > anim_frames/k:
#			get_tree().paused = true
#			k = 1 - 0.5 * (anim_frames-anim_frames_current)/(2*anim_frames/3)
			$Sprite.scale.y = 1 - max_shrink * (anim_frames-anim_frames_current)/((k-1)*anim_frames/k)
		else:
#			k = 1 - 0.5 * anim_frames_current/(anim_frames/3)
			$Sprite.scale.y = 1 - max_shrink * anim_frames_current/(anim_frames/k)
		$Sprite.position.y = -24 + 24*(1-$Sprite.scale.y)
#		$Sprite.scale.y = 1 - 0.5 * (anim_frames-anim_frames_current)/(anim_frames)
	if jumping:
#		print(velocity.y)
		pass
	pass
