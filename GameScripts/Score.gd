extends Control

onready var num = $Num
onready var num2  = $Num2
onready var num3 = $Num3

export var score = 000 setget set_score

func set_score(value):
	score = value
	if score > 99:
		num.current_num = int(str(score)[0])
		num2.current_num = int(str(score)[1])
	elif score > 9:
		num2.current_num = int(str(score)[0])
	num3.current_num = int(str(score)[-1])
	$AnimationPlayer.play("num")
