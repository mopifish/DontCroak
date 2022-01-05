extends Node2D

var is_left_usable = false setget ,left_usable
var is_right_usable = false setget ,right_usable
var is_front_usable = false setget ,front_usable

func left_usable():
	for child in get_children():
		if child.side == "LeftWall" and not child.is_in_group("SecretWall"):# and child.has_required_item():
			return true

func right_usable():
	for child in get_children():
		if child.side == "RightWall" and not child.is_in_group("SecretWall"): #and child.has_required_item():
			return true

func front_usable():
	for child in get_children():
		if child.side == "FrontWall" and not child.is_in_group("SecretWall"): #and child.has_required_item():
			return true
