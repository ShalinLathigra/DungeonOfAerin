extends Area2D

export(bool) var specific_key;

var used: bool;

func _enter_tree():
	$AnimationPlayer.play("Idle");

func _on_Key_body_entered(body):
	if not used and body.is_in_group("Player"): 
		animate_pickup();
		PlayerData.add_key(get_instance_id() if specific_key else -1);
		used = true;

func animate_pickup():
	$AnimationPlayer.play("Use");
