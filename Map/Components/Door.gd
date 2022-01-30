extends StaticBody2D

export(bool) var locked;
export(bool) var special_key;
export(NodePath) var key_start_path;

var key_id: int;

func _enter_tree():
	var key = get_node_or_null(key_start_path);
	if key:
		key_id = key.get_instance_id();

func try_unlock():
	if not special_key and PlayerData.use_key():
		locked = false;
	if special_key and PlayerData.use_key(key_id):
		locked = false;
	# structured like this in case the door is pre-unlocked.
	if not locked:
		animate_open();

func animate_open():
	modulate = Color("00000000");
	collision_layer = 0;


func _on_UnlockArea_body_entered(body):
	if body.is_in_group("Player"): 
		try_unlock();
