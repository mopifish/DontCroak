extends Control

onready var item_array = [
	[get_node("Background/Control/1"),get_node("Background/Control/2"),get_node("Background/Control/3"),get_node("Background/Weapons/1"),get_node("Background/Weapons/2"),get_node("Background/Weapons/3"),],
	[get_node("Background/Control/4"),get_node("Background/Control/5"),get_node("Background/Control/6"),]
]

onready var highlight = $Background/Control/Highlight
onready var inventorySwitcher = $InventorySwitcher

var bag_coord = Vector2() setget set_bag_coord
onready var current_item setget ,get_item

enum {
	WEAPON,
	ITEM
}

var state = ITEM setget set_state

func set_state(value):
	state = value
	if state == ITEM:
		$Background/Control.visible = true
		$Background/Weapons.visible = false
		highlight = $Background/Control/Highlight
	else:
		$Background/Control.visible = false
		$Background/Weapons.visible = true
		highlight = $Background/Weapons/Highlight

func add_item(item):
	highlight.visible = true
	var container = $Background/Control
	var end_coord = 6
	if item.Class == "Weapon":
		container = $Background/Weapons
		end_coord = 3
	
	for i in range (0, end_coord):
		if container.get_child(i).get_child_count() == 0:
			container.get_child(i).add_child(item)
			container.get_child(i).get_child(0).position = Vector2()
			break

func remove_item():
	item_array[bag_coord.y][bag_coord.x].remove_child(self.current_item)

func set_bag_coord(value):
	var y_clamp = 1
	if value.x == 2 and state == WEAPON:
		self.state = ITEM
		inventorySwitcher.play_backwards("change")
		value.y = 0
	elif value.x == 3 and state == ITEM:
		self.state = WEAPON
		inventorySwitcher.play("change")
		y_clamp = 0
	bag_coord = Vector2(clamp(value.x, 0, 5),clamp(value.y, 0, y_clamp))
	highlight.rect_position = item_array[bag_coord.y][bag_coord.x].rect_position - Vector2(6,6)
	if state == WEAPON:
		highlight.rect_position -= Vector2(1, 3)

func use():
	if has_item():
		self.current_item.use()

func has_item():
	return item_array[bag_coord.y][bag_coord.x].get_child_count() > 0

func get_item():
	if has_item():
		return item_array[bag_coord.y][bag_coord.x].get_child(0)

func get(item):
	for i in range(0, 6):
		if $Background/Control.get_child(i).get_child_count() != 0 and item == $Background/Control.get_child(i).get_child(0).filename:
			return $Background/Control.get_child(i).get_child(0)

func has(item):
	if item == "": return true
	for i in range(0, 6):
		if $Background/Control.get_child(i).get_child_count() != 0 and item == $Background/Control.get_child(i).get_child(0).filename:
			return true
