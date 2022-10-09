extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var platform_distance_from_max_height = 0.9 
export (float) var platform_broken_chance = 0.1

var Player_scene = preload("res://Scenes/Player.tscn")
var Player
var Platform_scene = preload("res://Scenes/Platform.tscn")
var Platform_broken_scene = preload("res://Scenes/Platform broken.tscn")

var prev_collider
var top_platform

var camera_moving = false
var camera_path
var camera_time = 20
var camera_remaining_time

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.score = 0
	seed("Dude Jump".hash())
	randomize()
	
	$Label.text = str(ceil(Globals.score))
	Player = Player_scene.instance()
	self.add_child(Player)
	Player.global_position = Vector2(get_viewport_rect().size.x/2, 4*get_viewport_rect().size.y/5)
	
	var first_platform = Platform_scene.instance()
	self.add_child(first_platform)
	first_platform.add_to_group("Platforms")
	first_platform.global_position = Vector2(Player.global_position.x, 9*get_viewport_rect().size.y/10)
	prev_collider = first_platform
	top_platform = first_platform
	for i in range((get_viewport_rect().size.y / Player.max_allowed_height)):
		spawn_platform()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Player:
		collision_fix()
		add_score()
		if camera_moving:
			for c in self.get_children():
				if (not c is Label) and (not c is Control):
					c.global_position.y += camera_path/camera_time
			get_node("../TileMap").global_position.y += camera_path/camera_time
			if camera_remaining_time <= camera_time /2:
				$Label.get_font("font").size -= 32/camera_time
			else:
				$Label.get_font("font").size += 32/camera_time
			
			camera_remaining_time -= 1
			if camera_remaining_time == 0:
				camera_moving = false 
		pass
	pass

func add_score():
	if Player.collision:
		if prev_collider != Player.collision.collider:
			if prev_collider.global_position.y != Player.collision.collider.global_position.y:
				Globals.score += (prev_collider.global_position - Player.collision.collider.global_position).length()
				$Label.text = str(ceil(Globals.score))
				move_camera()
				prev_collider = Player.collision.collider
	pass

func move_camera():
	camera_moving = true
	$Label.get_font("font").size = 32
	camera_remaining_time = camera_time
	camera_path = 9*get_viewport_rect().size.y/10 - Player.collision.collider.global_position.y
	spawn_platform()
	pass

func spawn_platform():
	var p = Platform_scene.instance()
	self.add_child(p)
	p.add_to_group("Platforms")
	var x = randi() % int(get_viewport_rect().size.x - 92*2) + 92
	p.global_position = Vector2(x, int(top_platform.global_position.y - Player.max_allowed_height * platform_distance_from_max_height))
	top_platform = p
	if randi() % 100 < platform_broken_chance*100:
		spawn_platform_broken()
	self.move_child($Label, self.get_child_count())
	pass

func spawn_platform_broken():
	var p = Platform_broken_scene.instance()
	self.add_child(p)
	p.add_to_group("Platforms")
	var possible_pos = [[92, top_platform.global_position.x-92-92-32], [top_platform.global_position.x+92+92+32, int(get_viewport_rect().size.x - 92)]]
	for i in possible_pos:
		if i[1] - i[0] <0:
			possible_pos.erase(i)
	var k = randi() % possible_pos.size()
	var x = rand_range(possible_pos[k][0], possible_pos[k][1])
#	var x = randi() % int(get_viewport_rect().size.x - 92*2) + 92
	p.global_position = Vector2(x, top_platform.global_position.y)
	self.move_child($Label, self.get_child_count())
	pass

func collision_fix():
	var platforms = get_tree().get_nodes_in_group("Platforms")
#	for index in Player.get_slide_count():
#		var collision = Player.get_slide_collision(index)
#		var p = collision.collider.get_node("./CollisionPolygon2D")
#		p.disabled = p.global_position.y <= Player.global_position.y + 500
	for platform in platforms:
		if platform.global_position.y > get_viewport_rect().size.y:
			platform.queue_free()
		if not platform.get_meta("player_collided"):
			platform.get_node("./CollisionPolygon2D").disabled = platform.global_position.y <= Player.global_position.y
			platform.get_node("./CollisionPolygon2D").visible = not platform.get_node("./CollisionPolygon2D").disabled
		else:
			if platform.get_node("./CollisionPolygon2D").disabled:
				platform.get_node("./CollisionPolygon2D").disabled = false
			platform.get_node("./CollisionPolygon2D").visible = not platform.get_node("./CollisionPolygon2D").disabled
	pass
