extends "res://Items/Item.gd"

export var text = ""

func _ready():
	$CanvasLayer/Label.text = text

func use():
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/read_paper.wav", audioStreamPlayer)
	$CanvasLayer/Label.visible = not $CanvasLayer/Label.visible
	
	world.drop_button.disabled = true
	world.bag_button.disabled = not world.bag_button.disabled
	
	world.up_arrow.disabled = true
	world.down_arrow.disabled = true
	world.left_arrow.disabled = true
	world.right_arrow.disabled = true
	
	if not $CanvasLayer/Label.visible:
		$AnimationPlayer.play("Delete")
		world.use_button.disabled = true
		world.drop_button.disabled = true
		yield($AnimationPlayer, "animation_finished")
		world.disable_buttons()
