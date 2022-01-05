extends "res://Items/Item.gd"

export var use_time:float

func _ready():
	set_process(false)
	$Timer.wait_time = use_time

func use():
	if world.is_monsters():
		$AnimationPlayer.play("Drop")
		yield(get_tree().create_timer(0.5), "timeout")
		AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/meat_toss.wav", world.audioStreamPlayer)
		var monster_list = get_tree().get_nodes_in_group("Monster")
		get_parent().remove_child(self)
		monster_list[0].add_child(self)
		get_parent().distracted = true
		set_process(true)
		$Timer.start()
		position.y += 10

func _on_Timer_timeout():
	get_parent().distracted = false

func _process(delta):
	scale = Vector2($Timer.wait_time/use_time, $Timer.wait_time/use_time)

func _on_Meat_tree_exiting():
	if get_parent().is_in_group("Monster"):
		get_parent().distracted = false
