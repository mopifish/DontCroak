extends Sprite

export var rarity:int

func _ready():
	var roll = int(rand_range(0, 100))
	if roll <= rarity:
		self.visible = true
	
