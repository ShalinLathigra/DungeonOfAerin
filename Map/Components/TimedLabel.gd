extends Label

export (int) var num_ms;
export(String, FILE) var destination;

# set during animation
export (bool) var active = false;

var start_time_ms;

func set_params ():
	start_time_ms = OS.get_ticks_msec()
	update_text()

func update_text():
	var t = float(num_ms - (OS.get_ticks_msec() - start_time_ms)) / 1000.0
	var mins = int(floor(t / 60.0))
	var secs = int(floor(fmod(t, 60.0)))
	text = "%02d:%02d" % [mins, secs]
	if t <= 0 and active:
		OS.shell_open("https://thekingdomofaerin.io/")
		active = false
		text = "You survived!!! \n https://thekingdomofaerin.io/"
		SceneLoader.goto_scene(destination)

func _process(_delta):
	if not active: return
	update_text()
