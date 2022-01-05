extends Node2D

onready var room = $Rooms.get_child(0) setget set_room
onready var monsters
onready var items 
onready var usables 
onready var last_room = room
onready var score = $Score

onready var up_arrow = $UI/UpArrow
onready var down_arrow = $UI/DownArrow
onready var left_arrow = $UI/LeftArrow
onready var right_arrow = $UI/RightArrow
onready var use_button = $UI/UseButton
onready var attack_button = $UI/AttackButton
onready var bag_button = $UI/BagButton
onready var drop_button = $UI/DropButton
onready var live_button = $Gameover/LiveButton
onready var die_button = $Gameover/DieButton
onready var current_button = room.start_button

onready var bag = $Bag
onready var map = bag.get("res://Items/Map.tscn")
onready var player = $Player
onready var attackTimer = $UI/AttackTimer
onready var gameover = $Gameover
onready var audioStreamPlayer = $AudioStreamPlayer
onready var fireCrackle = $FireCrackle
onready var buttonClicker = $ButtonClicker

enum {MOVING, ATTACKING, USING, BAG, GAMEOVER, MENU, WIN}
var state = MENU setget set_state

func set_state(value):
	state = value
	disable_buttons()
func set_room(value):
	room = value
	monsters = room.get_node("Monsters")
	items = room.get_node("Items")
	usables = room.get_node("Usables")

func _ready():
	disable_buttons()

func _on_UpArrow_pressed():
	_use_arrow_button(room.front_door, "FrontWall", 0, Vector2(0, -1))
func _on_RightArrow_pressed():
	_use_arrow_button(room.right_door, "RightWall", 1, Vector2(1, 0))
func _on_LeftArrow_pressed():
	_use_arrow_button(room.left_door, "LeftWall", 0, Vector2(-1, 0))
func _on_DownArrow_pressed():
	_use_arrow_button(room.back_door, "BackWall", null, Vector2(0, 1))

func _on_AttackButton_toggled(button_pressed):
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/button.wav", buttonClicker)
	if attackTimer.is_stopped():
		if self.state == ATTACKING: self.state = MOVING
		if button_pressed:
			self.state = ATTACKING
func _on_UseButton_toggled(button_pressed):
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/button.wav", buttonClicker)
	if state == BAG:
		if button_pressed:
			bag.use()
			yield(get_tree().create_timer(.1), "timeout")
			use_button.pressed = false
			#if bag.current_item.name == "Paper" and not bag.current_item.get_node("CanvasLayer/Label").visible: disable_buttons()
	elif state == GAMEOVER or state == MENU or state == WIN:
		if button_pressed:
			use_button.disabled = true
			left_arrow.disabled = true
			right_arrow.disabled = true
			current_button.emit_signal("pressed")
			use_button.pressed = false
	else:
		self.state = MOVING
		if button_pressed:
			self.state = USING
func _on_BagButton_toggled(button_pressed):
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/button.wav", buttonClicker)
	get_tree().paused = button_pressed
	bag.visible = button_pressed
	self.state = MOVING
	if button_pressed:
		self.state = BAG
func _on_DropButton_pressed():
	if bag.current_item.name == "Meat" and is_monsters():
		bag.current_item.use()
		return
	
	left_arrow.disabled = true
	right_arrow.disabled = true
	up_arrow.disabled = true
	down_arrow.disabled = true
	use_button.disabled = true
	drop_button.disabled = true
	
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/button.wav", buttonClicker)
	var item = bag.current_item
	if item == player.weapon: player.weapon = player.weapon
	item.get_node("AnimationPlayer").play("Drop")
	yield(get_tree().create_timer(0.5), "timeout")
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/drop.wav", audioStreamPlayer)
	bag.remove_item()
	items.add_child(item)
	for i in range(0,4):
		var j = 4
		while j < items.get_child_count():
			if items.get_child(j).position == items.get_child(i).position:
				i += 1
				j = 4
			else:
				j += 1
		item.position = items.get_child(i).position
		break
	disable_buttons()

func _on_LiveButton_pressed():
	live_button.pressed = true
	if audioStreamPlayer.playing:
		return
	#AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/live_button.wav", audioStreamPlayer)
	get_node("BackgroundNoise").stream = load("res://Lowrez Dungeoncrawl Assets/Sounds/cave_noises.wav")
	get_node("BackgroundNoise").play()
	#yield(audioStreamPlayer, "finished")
	player.health = player.lives
	
	var checkpoint = LevelData.room_scenes["CheckPoint"]
	EffectHandler.instance_fade_effect(get_parent())
	move_rooms(checkpoint.filename)
	yield(get_tree().create_timer(.4), "timeout")
	get_tree().paused = false
	gameover.visible = false
	live_button.pressed = false
	self.state = MOVING
func _on_DieButton_pressed():
	die_button.pressed = true
	LevelData.room_scenes = {CheckPoint = null}
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().paused = false

func _use_arrow_button(new_room, door, monster_num, bag_vector):
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/button.wav", buttonClicker)
	match state:
		MOVING:
			move_rooms(new_room)
		ATTACKING:
			attack_monster(monster_num)
		USING:
			use(door)
		BAG:
			bag.bag_coord += bag_vector
		GAMEOVER:
			live_button.disabled = true
			die_button.disabled = true
			current_button = die_button
			if door == "LeftWall":
				current_button = live_button
			current_button.disabled = false
		MENU:
			
			if room.exit_button.visible:
				room.start_button.disabled = true
				room.exit_button.disabled = true
				current_button = room.exit_button
				if door == "LeftWall":
					current_button = room.start_button
				current_button.disabled = false
			else:
				room.yes.disabled = true
				room.no.disabled = true
				current_button = room.no
				if door == "LeftWall":
					current_button = room.yes
				current_button.disabled = false
	disable_buttons()

func disable_buttons():
	drop_button.visible = false
	match state:
		MOVING:
			up_arrow.disabled = room.front_door == "" or room.is_blocked("FrontWall") or (is_monsters() and not monsters_distracted()) or is_not_lit()
			down_arrow.disabled = room.back_door == "" or is_not_lit()
			left_arrow.disabled = room.left_door == "" or room.is_blocked("LeftWall") or (is_monsters() and not monsters_distracted()) or is_not_lit()
			right_arrow.disabled = room.right_door == "" or room.is_blocked("RightWall") or (is_monsters() and not monsters_distracted()) or is_not_lit()
			use_button.disabled = not (is_usables() or is_items()) or is_not_lit() or is_monsters()
			attack_button.disabled = not is_monsters() or is_not_lit()
			bag_button.disabled = false
			
			if not is_monsters(): enable_last_direction()
		USING:
			up_arrow.disabled = not usables.is_front_usable
			left_arrow.disabled = not usables.is_left_usable
			right_arrow.disabled = not usables.is_right_usable
			down_arrow.disabled = not is_items() or items.get_child(4).get_node("AnimationPlayer").current_animation == "Pickup"
		ATTACKING:
			left_arrow.disabled = not monsters.get_child_count() == 4 or not attackTimer.is_stopped()
			right_arrow.disabled = not monsters.get_child_count() == 4 or not attackTimer.is_stopped()
			up_arrow.disabled = not monsters.get_child_count() == 3 or not attackTimer.is_stopped()
			down_arrow.disabled = true
			attack_button.disabled = not is_monsters()
			if not is_monsters():
				attack_button.pressed = false
				state = MOVING
		BAG:
			left_arrow.disabled = bag.bag_coord.x < 1
			right_arrow.disabled = bag.bag_coord.x > 4 
			up_arrow.disabled = bag.bag_coord.y < 1 
			down_arrow.disabled = bag.bag_coord.y > 0 or bag.state == 0 
			use_button.pressed = false
			use_button.disabled = not bag.has_item() or bag.current_item.Class == "Tool"
			attack_button.pressed = false
			attack_button.disabled = true
			drop_button.disabled = not bag.has_item() or bag.current_item.name == "Map"
			drop_button.visible = true
		GAMEOVER:
			if not gameover.visible:
				gameover.visible = true
				$Gameover/Label2.text = "Lives: " + str(player.lives) 
				if player.lives > 0:
					current_button = live_button
				else:
					current_button = die_button
			attack_button.disabled = true
			attack_button.pressed = false
			bag_button.disabled = true
			bag_button.pressed = false
			use_button.disabled = false
			use_button.pressed = false
			up_arrow.disabled = true
			down_arrow.disabled = true
			right_arrow.disabled = current_button.name == "DieButton"
			left_arrow.disabled = not right_arrow.disabled
		MENU:
			use_button.disabled = false
			right_arrow.disabled = current_button.name == "Exit" or current_button.name == "No"
			left_arrow.disabled = not right_arrow.disabled
		WIN:
			attack_button.disabled = true
			attack_button.pressed = false
			bag_button.disabled = true
			bag_button.pressed = false
			use_button.disabled = false
			use_button.pressed = false
			up_arrow.disabled = true
			down_arrow.disabled = true
			left_arrow.disabled = true
			right_arrow.disabled = true

func move_rooms(new_room_path):
	#Instances new room. If the room has already been instanced, loads it instead.
	var new_room = load(new_room_path).instance()
	if new_room.name in LevelData.room_scenes:
		new_room = LevelData.room_scenes[new_room.name]
	
	EffectHandler.instance_fade_effect(self, 1.5)
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/footsteps.wav", audioStreamPlayer)
	yield(get_tree().create_timer(0.4), "timeout")
	
	last_room = room
	$Rooms.remove_child(room)
	$Rooms.add_child(new_room)
	self.room = new_room
	
	room.light_room()
	fireCrackle.stream = load("res://Lowrez Dungeoncrawl Assets/Sounds/fire_crackle.wav")
	fireCrackle.playing = room.is_dark and is_light_source()
	map.update_map(room.name)
	
	state = MOVING
	disable_buttons()
func attack_monster(monster_num):
	var monster = get_tree().get_nodes_in_group("Monster")[monster_num]
	if monster.animationPlayer.current_animation != "die":
		if player.damage_type == "Slash":
			EffectHandler.instance_slash_effect(monster)
			AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/slash.wav", audioStreamPlayer)
		else:
			EffectHandler.instance_smash_effect(monster)
			AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/smash2.wav", audioStreamPlayer)
		monster.health -= player.attack
		player.play("Attack")
		attackTimer.start()
		attack_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
func use(door):
	if door == "BackWall" and is_items(): #if there are items and you've pressed the back button
		var item = items.get_child(4)
		if bag_full(item.Class):
			item.get_node("AnimationPlayer").play("BagFull")
			AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/bag_full.wav", audioStreamPlayer)
			return
		item.get_node("AnimationPlayer").play("Pickup")
		AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/pickup1.wav", audioStreamPlayer)
		use_button.disabled = true
		yield(get_tree().create_timer(1.2), "timeout")
		AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/bag.wav", audioStreamPlayer)
		items.remove_child(item)
		bag.add_item(item)
		use_button.disabled = false
	else:
		for i in range(usables.get_child_count()-1, -1, -1): #For loop iterates backwards. Small polish feature that makes sure usables closer to the player are used first
			var child = usables.get_child(i)
			if child.side == door and not child.is_in_group("SecretWall"):
				child.use()
				break
		
	use_button.pressed = false
	if state == USING: self.state = MOVING #Prevents state from switching if bag was opened

func is_monsters():
	return room.get_node("Monsters").get_child_count() > 2
func is_items():
	return items.get_child_count()>4
func is_usables():
	if usables.get_child_count() == 1 and usables.get_child(0).is_in_group("SecretWall"):
		return false
	return usables.get_child_count()>0
func is_light_source():
	if get_tree() != null: #This is... a really weird condition. But without it game crashes if you close it in a dark monster room
		for node in get_tree().get_nodes_in_group("LightSource"): #If no light source nodes exist in the current scene, for loop will terminate immediately
			return true
		return false
func monsters_distracted():
	if get_tree() == null:
		return
	var monster_list = get_tree().get_nodes_in_group("Monster")
	for monster in monster_list:
		if monster.distracted == false:
			return false
	return true
func is_not_lit():
	return (room.is_dark and not is_light_source())
func bag_full(Class):
	var list = bag.get_node("Background/Control").get_children()
	if Class == "Weapon":
		list = bag.get_node("Background/Weapons")
	for i in range(0, len(list)-2):
		if list[i].get_child_count() == 0:
			return false
	return true
func enable_last_direction():
	if last_room.filename == room.left_door:
		left_arrow.disabled = false
	elif last_room.filename == room.right_door:
		right_arrow.disabled = false
	elif last_room.filename == room.front_door:
		up_arrow.disabled = false
	elif last_room.filename == room.back_door:
		down_arrow.disabled = false

func _on_AttackTimer_timeout():
	attack_button.mouse_filter = Control.MOUSE_FILTER_STOP
	disable_buttons()

func _on_Gameover_visibility_changed():
	if player.lives == 0:
		$Gameover/Label.text = "die"
		die_button.rect_position.x -= 10
		live_button.disabled = true
