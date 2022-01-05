extends Sprite

onready var shiftyTimer = $ShiftyTimer
onready var attackTimer = get_parent().get_node("UI/AttackTimer")

export var health:float = 5 setget set_health
var lives = health
export var max_health:float = 6
export var attack = 0.5
var weapon setget set_weapon
var damage_type = "Smash"
var defense = 1 

const max_shifty_time = 10
const min_shifty_time = 5

var dying

func set_face():
# warning-ignore:narrowing_conversion
	frame = clamp(max_health - health, 0, max_health-1)

func set_health(value):
	if value < health:
		play("Hurt")
		AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/squeak.wav", get_parent().audioStreamPlayer)
	elif value > health and not health <= 0:
		play("Heal")
	
	value = health - ((health-value)/defense)
	health = clamp(value, 0, max_health)
	$TextureProgress.value = health*10
	if health <= 0:
		die()

func set_weapon(value):
	if weapon != value:
		weapon = value
		attack = weapon.damage
		damage_type = weapon.damage_type
		attackTimer.wait_time = weapon.recovery_time
		get_parent().get_node("CurrentWeapon").texture = weapon.get_node("Sprite").texture
	else:
		weapon = null
		attack = 0.5
		attackTimer.wait_time = 0.8
		damage_type = "Smash"
		get_parent().get_node("CurrentWeapon").texture = null

func _ready():
	shiftyTimer.wait_time = rand_range(min_shifty_time, max_shifty_time)
	shiftyTimer.start()

func die():
	if dying:
		return
	dying = true
	get_parent().get_node("BackgroundNoise").stream = load("res://Lowrez Dungeoncrawl Assets/Sounds/game_over_music.wav")
	get_parent().get_node("BackgroundNoise").play()
	EffectHandler.instance_fade_effect(get_parent())
	lives -= 1 # optional. 
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().paused = true
	get_parent().state = get_parent().GAMEOVER
	dying = false

func play(animation):
	$PlayerAnimator.play(animation)

func _on_PlayerAnimator_animation_finished(_anim_name):
	play("Resting")
func _on_ShiftyTimer_timeout():
	$BlinkPlayer.play("Blink")
	shiftyTimer.wait_time = rand_range(min_shifty_time, max_shifty_time)
	shiftyTimer.start()

func play_sound(sound):
	AudioHandler.play(sound, get_parent().audioStreamPlayer)
