extends AudioClipPlayer

class_name DelayedRepeater

export(float) var delay;
export(Array, Resource) var audioclip_set;

var index: int;
var clip_count: int;
var coroutine;

func _enter_tree():
	clip_count = audioclip_set.size();

func play_audio():
	if (playing): return;
	index = 0;
	insert_next_clip();
	$AudioPlayer.play(0.0);
	playing = true;
	
func insert_next_clip():
	current_clip = audioclip_set[index % clip_count];
	$AudioPlayer.stream = current_clip.clip;
	$AudioPlayer.volume_db = current_clip.volume;
	$AudioPlayer.pitch_scale = current_clip.pitch;
	
func stop_audio():
	playing = false;


func _on_AudioPlayer_finished():
	if playing:
		$AudioPlayer.stop();
		$Timer.start(delay);
		yield($Timer, "timeout");
		index += 1;
		insert_next_clip();
		$AudioPlayer.play(0.0);
