extends Node

export(bool) var manual_toggle;

func _enter_tree():
	if (manual_toggle):
		SceneLoader.current_scene = self;
		animate_entry();

func animate_entry():	
	$AnimationPlayer.play("animate_entry");
	return $AnimationPlayer.get_animation("animate_exit").length

func animate_exit():
	$AnimationPlayer.play("animate_exit")
	return $AnimationPlayer.get_animation("animate_exit").length
