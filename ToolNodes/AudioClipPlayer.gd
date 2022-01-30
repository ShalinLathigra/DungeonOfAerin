extends Node
class_name AudioClipPlayer

export(bool) var start_clip_trigger setget start_clip;

export(bool) var playing;
export(Resource) var current_clip;

func _enter_tree():
	print(name)
	$AudioPlayer.stream = current_clip.clip;
	$AudioPlayer.volume_db = current_clip.volume;
	$AudioPlayer.pitch_scale = current_clip.pitch;
	
func play_audio():
	if (playing): return;
	$AudioPlayer.play(0.0);
	playing = true;
	
func stop_audio():
	playing = false;
	
func _on_AudioPlayer_finished():
	playing = false;

func start_clip(_input):
	play_audio();
