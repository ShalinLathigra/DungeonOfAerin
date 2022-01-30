tool
extends CollisionShape2D

export(NodePath) var target;
export(bool) var update;

func _process(_delta):
	if update:
		var n = get_node_or_null(target);
		n.set_shape(shape);
	update = false;
