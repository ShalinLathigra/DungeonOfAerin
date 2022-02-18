extends Node

# Add preloads and paths here!
var loaded_objects = {}

func load_component(path):
	var ret = loaded_objects.get(path, false)
	if not ret:
		ret = load(path)
		loaded_objects[path] = ret;
	return ret;
