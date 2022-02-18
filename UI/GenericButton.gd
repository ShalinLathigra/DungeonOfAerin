extends TextureButton

export(String, FILE) var next
export(NodePath) var anim
export(NodePath) var aud

export(Resource) var hover_clip
export(Resource) var press_clip

var used: bool;
var player: AnimationPlayer;
var audio: AudioClipPlayer;
func _ready():
	SceneRef.load_component(next)
	if anim: player = get_node(anim);
	if hover_clip: audio = get_node(aud);
	
	
func _on_TextureButton_pressed():
	if audio and press_clip:
		audio.start_clip(press_clip);
	load_scene();

func _on_SceneButton_mouse_entered():
	if audio and hover_clip:
		audio.start_clip(hover_clip);


func load_scene():
	if not used:
		SceneLoader.goto_scene(next);
		used = true
