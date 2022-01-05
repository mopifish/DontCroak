extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var world = get_tree().get_current_scene()
onready var attackTimer = $AttackTimer

export var health:float setget set_health
export var stagger:float
export var attack:float
export var AttackDelay:float
export var score_increase:int

export var distracted = false setget set_distracted

func _ready():
	connect("tree_exited", world, "disable_buttons")
	connect("tree_exiting", get_parent(), "_enemy_exiting_tree")
	if get_parent().get_child_count() > 3:
		if get_parent().get_child(3) == self:
			attackTimer.paused = true
			yield(get_tree().create_timer(1), "timeout")
			attackTimer.paused = false
	#attackTimer.wait_time = rand_range(AttackDelay, AttackDelay + 1)
	attackTimer.start()

func set_health(value):
	if animationPlayer == null:
		health = value
		return
	
	if value < health and animationPlayer.current_animation != "die":
		if attackTimer.is_stopped():
			if (health - value) >= stagger:
				animationPlayer.play("Stagger")
				_restart_attack()
		else:
			animationPlayer.play("Hurt")
	health = value
	if health <= 0:
			attackTimer.paused = true
			animationPlayer.play("Stagger")
			_restart_attack() #This prevents the bug from cancelling damage by attacking

func check_for_death():
		if health <= 0:
			world.score.score += score_increase
			AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/monster_dying.wav", world.audioStreamPlayer)
			animationPlayer.play("die")
		else:
			animationPlayer.play("Resting")

func _on_AttackTimer_timeout():
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/monster_attack.wav", world.audioStreamPlayer)
	animationPlayer.play("Attack")
func damage_player():
	world.player.health -= attack

func _restart_attack():
	attackTimer.wait_time = rand_range(AttackDelay, AttackDelay + 0.5)
	attackTimer.start()

func set_distracted(value):
	distracted = value
	if world == null:
		return
	world.disable_buttons()
	if distracted:
		attackTimer.stop()
		AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/monster_eating.wav", world.fireCrackle)
		animationPlayer.play("Eat")
	else:
		animationPlayer.play("Resting")
		for node in get_children():
			if node.is_in_group("Distracter"):
				node.queue_free()
				break
		_restart_attack()

func _on_Enemy_tree_entered():
	yield(get_tree().create_timer(0.1), "timeout")
	_restart_attack()
