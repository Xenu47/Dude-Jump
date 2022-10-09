extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Globals = get_node("/root/Globals")
var Player_scene = preload("res://Scenes/Player.tscn")
var Player
var Game_scene = preload("res://Scenes/Game.tscn")
var Retry_scene = preload("res://Scenes/Retry.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(640, 960))
	Globals.load_game()
#	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Globals.time += delta
	pass # Replace with function body.



func game_over():
	if Globals.highscore < Globals.score:
		Globals.highscore = Globals.score
	Globals.save_game()
#	get_tree().paused = true
	if $Game:
		$Game.queue_free()
	var retry = Retry_scene.instance()
	self.add_child(retry)
	$Retry/Button.connect("pressed", self, "_on_Button_Retry_pressed")
	$Retry/Button2.connect("pressed", self, "_on_Button_Menu_pressed")
	get_node("Menu").visible = false
	get_node("Menu").set_physics_process(false)
	pass


func start_game():
#	get_tree().paused = false
	var game = Game_scene.instance()
	self.add_child(game)
	if $Retry:
		$Retry.queue_free()
	get_node("Menu").visible = false
	get_node("Menu").set_physics_process(false)
	pass


func _on_Button_pressed():
	start_game()
	pass # Replace with function body.


func _on_Button_Retry_pressed():
	start_game()
	pass # Replace with function body.


func _on_Button_Menu_pressed():
#	get_tree().paused = true
	if $Retry:
		$Retry.queue_free()
	get_node("Menu").visible = true
	get_node("Menu").set_physics_process(true)
	pass # Replace with function body.
