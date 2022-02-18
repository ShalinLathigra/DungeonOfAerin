extends AudioClipPlayer
class_name DelayedRepeater

export(float) var delay;
export(Array, Resource) var audioclip_set;

var index: int;
var clip_count: int;
var repeating: bool
var finished: bool
var coroutine;

func _enter_tree():
	clip_count = audioclip_set.size();

func play_audio(forced: bool = false):
	if playing or not finished and not forced: return;
	index = 0;
	insert_next_clip();
	play(0.0);
	repeating = true;
	finished = false
	
func insert_next_clip():
	current_clip = audioclip_set[index % clip_count];
	stream = current_clip.clip;
	volume_db = current_clip.volume;
	pitch_scale = current_clip.pitch;
	
func stop_audio():
	repeating = false
	finished = true


func _on_DelayedRepeater_finished():
	if repeating:
		stop();
		$Timer.start(delay);
		yield($Timer, "timeout");
		finished = true
		index += 1;
		insert_next_clip();
		play(0.0);	
