extends Node

var current_scene: Node;

func goto_scene(path: String):
	print("Goto scene ", path)
	call_deferred("__deferred_goto_scene", path)

func __deferred_goto_scene(path: String):
	var s = SceneRef.load_component(path)
	if not s: return
	var new_scene = s.instance()
	var pause_duration = 0	
	if current_scene.has_method("animate_exit"):
		pause_duration = current_scene.animate_exit()	
	yield(get_tree().create_timer(pause_duration), "timeout")
	
	get_tree().get_root().add_child(new_scene)
	if new_scene.has_method("animate_entry"):
		pause_duration = new_scene.animate_entry()
	else:
		pause_duration = 0
	yield(get_tree().create_timer(pause_duration), "timeout")
	
	current_scene = new_scene
