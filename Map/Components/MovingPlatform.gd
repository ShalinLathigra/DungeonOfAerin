extends StaticBody2D

export(Vector2) var offset;
export(float) var duration = 1.0;
export(float) var pause = 1.0;
export(bool) var active = true;
export(bool) var continuous = true;
export(bool) var permeable = false;

var t: float = 0.0;
var direction: float = 1.0;
var origin: Vector2;
var bot_occupied: bool
var top_occupied: bool

func _enter_tree():
	origin = position;

func _physics_process(delta):
	if Input.is_action_pressed("down"):
		toggle_collision(false)
	elif not bot_occupied and Input.is_action_just_released("down"):
		toggle_collision(true)
		
	if (active):
		t = clamp(t + delta * direction / duration, 0, 1);
		position = origin + offset*t;
		
		if (t == 0 or t == 1):
			constant_linear_velocity = Vector2.ZERO
			active = false;
			if continuous:
				$Timer.start(pause)
				yield ($Timer, "timeout");
				direction *= -1;
				$AudioClipPlayer.play_audio(true)
				constant_linear_velocity = offset / duration * direction;
				active = true;

func toggle_collision(toggle: bool = false):
	if permeable:
		 $Body.set_deferred("disabled", not toggle)
			
func _on_BotDetector_body_entered(_body):
	if top_occupied: return
	toggle_collision(false)
	bot_occupied = true; 
	
func _on_BotDetector_body_exited(_body):
	toggle_collision(true)
	bot_occupied = false

func _on_JumpArea_body_entered(_body):
	top_occupied = true

func _on_JumpArea_body_exited(_body):
	top_occupied = false
