tool
extends CollisionShape2D

export(NodePath) var target;

func _process(_delta):
	var n = get_node_or_null(target);
	n.set_shape(shape);
