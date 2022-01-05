extends Node2D

onready var start_button = $Start
onready var exit_button = $Exit
onready var yes = $Yes
onready var no = $No
onready var world = get_parent().get_parent()

export(String, FILE, "*.tscn") var tutorial_room
export(String, FILE, "*.tscn") var first_room

#oopsy hacky code teehee
var right_door
var left_door

func start_game(level):
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/start_game.wav", world.audioStreamPlayer)
	yield(world.audioStreamPlayer, "finished")
	EffectHandler.instance_fade_effect(world)
	yield(get_tree().create_timer(0.5), "timeout")
	var new_room = load(level).instance()
	get_parent().add_child(new_room)
	world.room = new_room
	world.last_room = new_room
	world.state = world.MOVING
	self.queue_free()

func _on_Start_pressed():
	start_button.pressed = true
	EffectHandler.instance_fade_effect(world)
	yield(get_tree().create_timer(0.5), "timeout")
	start_button.visible = false
	exit_button.visible = false
	yes.visible = true
	no.visible = true
	world.current_button = yes
	yes.disabled = false
	$Sprite.frame = 1
	world.disable_buttons()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Yes_pressed():
	world.map.level = world.map.get_node("CanvasLayer/Tutorial")
	start_game(tutorial_room)

func _on_No_pressed():
	world.map.level = world.map.get_node("CanvasLayer/Level1")
	start_game(first_room)
