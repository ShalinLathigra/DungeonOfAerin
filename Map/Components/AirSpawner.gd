extends Node2D
class_name AirSpawner

export(String, FILE) var objectType;
export(int) var shot_delay;
export(int) var time_of_last_shot;
export(bool) var active;

var direction: Vector2;
var instance_set: Array;
var last_index: int;

func _enter_tree():
	last_index = 0;
	SceneRef.load_component(objectType)
		
func _process(_delta):
	if not active: return;
	if OS.get_ticks_msec() > time_of_last_shot + shot_delay:
		var next = get_next_index();
		var directions = [-1.0, 1.0];
		var d = directions[randi() % 2];
		# horizontal_offset = 512 * -direction
		var h_offset = 640 * (-d);
		var v_offset = 96 * directions[randi() % 2]
		
		instance_set[next].init(d, global_position + Vector2(h_offset, v_offset));
		time_of_last_shot = OS.get_ticks_msec();

func get_next_index() -> int:
	# Find first available one, starting from last_index
	var should_generate = true;
	for i in range(instance_set.size()):
		var index = (last_index + i) % instance_set.size();
		if  not instance_set[index].active:
			should_generate = false;
			return index;
	if should_generate:
		instance_set.push_back(generate());
		return instance_set.size() - 1;
	return -1;
	
func generate():
	var scene: PackedScene = SceneRef.load_component(objectType)
	if (scene):
		var inst = scene.instance();
		add_child(inst);
		return inst;
	return false;

