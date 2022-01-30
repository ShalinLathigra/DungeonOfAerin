extends StaticBody2D

export(Vector2) var offset;
export(float) var duration = 1.0;
export(float) var pause = 1.0;
export(bool) var active = true;
export(bool) var continuous = true;

var t: float = 0.0;
var direction: float = 1.0;
var origin: Vector2;

func _enter_tree():
	origin = position;
	if (active):
		activate();

func _physics_process(delta):
	if (active):
		t = clamp(t + delta * direction / duration, 0, 1);
		position = origin + offset*t;
		
		if (t == 0 or t == 1):
			constant_linear_velocity = Vector2.ZERO
			active = false;
			if continuous:
				yield (get_tree().create_timer(pause), "timeout");
				direction *= -1;
				constant_linear_velocity = offset / duration * direction;
				active = true;

func activate(var toggle: bool = false):
	if toggle:
		direction *= -1;
	active = true;
