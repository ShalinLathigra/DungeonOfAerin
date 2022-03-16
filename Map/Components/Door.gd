extends StaticBody2D

export(bool) var locked;
export(bool) var special_key;
export(NodePath) var key_start_path;
export(Resource) var locked_clip;
export(Resource) var unlock_clip;
export(String, FILE) var destination;
var key_id: int;

		
func _enter_tree():
	var key = get_node_or_null(key_start_path);
	if key:
		key_id = key.get_instance_id();
	if destination:
		SceneRef.load_component(destination)
		modulate = Color(0,0,0,0)
	$Lock.visible = locked

func try_unlock():
	if not special_key and PlayerData.use_key():
		locked = false;
	if special_key and PlayerData.use_key(key_id):
		locked = false;
	# structured like this in case the door is pre-unlocked.
	if not locked:
		animate_open();
	else:
		animate_failed();

func animate_open():
	$AudioClipPlayer.current_clip = unlock_clip
	$AudioClipPlayer.play_audio(true)
	$Sprite.play("default")
	set_deferred("collision_layer", 0)
	$Lock.visible = false
	if destination:
		SceneLoader.goto_scene(destination)
	
func animate_failed():
	$AudioClipPlayer.current_clip = locked_clip
	$AudioClipPlayer.play_audio(true)

func _on_UnlockArea_body_entered(body):
	if body.is_in_group("Player"): 
		try_unlock();
