extends AudioStreamPlayer2D
class_name AudioClipPlayer

export(bool) var start_clip_trigger setget start_clip;
export(Resource) var current_clip;

func _enter_tree():
	if current_clip:
		stream = current_clip.clip;
		volume_db = current_clip.volume;
		pitch_scale = current_clip.pitch;
	
func play_audio(forced: bool = false):
	if playing and not forced: return;
	if not current_clip: return
	
	play(0.0);
	playing = true;
	
func stop_audio():
	playing = false;
	
func start_clip(input):
	if input is AudioClip:
		current_clip = input
		stream = current_clip.clip;
		volume_db = current_clip.volume;
		pitch_scale = current_clip.pitch;
	if current_clip:
		play_audio();
