extends Area2D
class_name Arrow

export(Vector2) var direction setget init;
export(float) var speed;

var active: bool;
var start_modulate: Color;

func _ready():
	active = false;
	modulate = Color("00000000");

func _physics_process(delta: float):
	if not active: return;
	position += direction * speed * delta;

func init(dir: Vector2):
	set_active(true);
	modulate = Color.red;
	direction = dir;
	rotation = direction.angle();
	position = Vector2.ZERO;

func _on_Arrow_body_entered(_body: Node):
	set_active(false);
	modulate = Color("00000000");

func set_active(a: bool):
	active = a;
	set_deferred("monitorable", a);
	set_deferred("monitoring", a);
