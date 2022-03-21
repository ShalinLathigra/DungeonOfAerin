extends KinematicBody2D

export (float) var horizontal_speed;
export (float) var frequency;
export (float) var amplitude;
export (float) var direction;
export (float) var life_max;
 
var start_pos: Vector2;
var start_time: int;
var active: bool;

func init(d, p):
	direction = d;
	start_pos = p;
	start_time = OS.get_ticks_msec();
	$Sprite.flip_h = d < 0;
	active = true;

func _physics_process(_delta):
	var t = float(OS.get_ticks_msec() - start_time) / 1000.0;
	global_position = start_pos + direction * Vector2(horizontal_speed * t, sin(frequency * t) * amplitude);
	active = t < life_max;
