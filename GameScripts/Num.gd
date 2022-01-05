extends TextureRect

enum{
	zero,
	one,
	two,
	three,
	four,
	five,
	six,
	seven,
	eight,
	nine,
}

export var current_num = zero setget set_current_num

func _ready():
	match_num()

func set_current_num(value):
	current_num = value
	match_num()

func match_num():
	match current_num:
		zero:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet1.png")
		one:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet2.png")
		two:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet3.png")
		three:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet4.png")
		four:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet5.png")
		five:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet6.png")
		six:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet7.png")
		seven:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet8.png")
		eight:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet9.png")
		nine:
			texture = load("res://Lowrez Dungeoncrawl Assets/UI/numbers/numbers_sheet10.png")
