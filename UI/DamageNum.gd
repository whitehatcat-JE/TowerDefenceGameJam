extends Label

@export var opacity_step:float = 1
@export var movement_step:float = 100

func _ready():
	position.x = 100	
	position.y = 100

func _init(value:float = 3.0, pos:Vector2 = Vector2(100,100)):
	text = String.num(value,0);
	position = pos;

func _process(delta:float):
	position.y -= movement_step*delta;
	modulate.a -= opacity_step*delta;
