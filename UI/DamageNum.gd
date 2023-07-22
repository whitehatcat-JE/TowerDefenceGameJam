extends Label

const opacity_step:float = 1
const movement_step:float = 100

func _ready():
	position.x = 100
	position.y = 100
	text = "Test"
	

func _init(value:float = 3.0):
	text = String.num(value,0);

func _process(delta:float):
	position.y -= movement_step*delta;
	modulate.a -= opacity_step*delta;
