extends Area2D
class_name Arrow

export(Vector2) var direction;
export(float) var speed;

var active: bool;
var start_modulate: Color;

func _ready():
	active = false;

func _physics_process(delta: float):
	if not active: return;
	position += direction * speed * delta;

func init(dir: Vector2):
	active = true;
	toggle_collisions(active);
	direction = dir;
	rotation = direction.angle();
	position = Vector2.ZERO;
	$Sprite.modulate = Color.white

func _on_Arrow_body_entered(_body: Node):
	direction = Vector2.ZERO
	toggle_collisions(false);
	$Sprite.play("Impact")

func toggle_collisions(a: bool):
	set_deferred("monitorable", a);
	set_deferred("monitoring", a);

func _on_Sprite_animation_finished():
	$Sprite.frame = 0	
	$Sprite.playing = false
	$Sprite.modulate = Color(0,0,0,0)
	active = false;
