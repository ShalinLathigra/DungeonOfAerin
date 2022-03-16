extends Sprite
class_name ObjectEmitter

export(String, FILE) var objectType;
export(float) var shots_per_second = 1.0;
export(int) var startup_delay_msec;
export(bool) var active;
export(Resource) var activate_clip;

var direction: Vector2;
var time_of_last_shot: int;
var instance_set: Array;
var last_index: int;
var shot_delay: int;

func _enter_tree():
	$DirectionIndicator.modulate = Color("00000000");
	direction = ($DirectionIndicator.position).normalized();
	last_index = 0;
	time_of_last_shot = startup_delay_msec;
	SceneRef.load_component(objectType)
	shot_delay = 1000 / shots_per_second
	if activate_clip: 
		$AudioClipPlayer.current_clip = activate_clip
		
func _process(_delta):
	if not active: return;
	if OS.get_ticks_msec() > time_of_last_shot + shot_delay:
		var next = get_next_index();
		instance_set[next].init(direction);
		$AudioClipPlayer.play_audio(true)
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

