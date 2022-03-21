extends Area2D
class_name GroundDetector

export(NodePath) var land_player_path;
export(NodePath) var land_particles_path;

var audio_enabled : bool;
var particle_enabled : bool;
var land_player : AudioClipPlayer;
var land_particles : CPUParticles2D;
var contacts = [];

func _enter_tree():
	land_player = get_node_or_null(land_player_path);
	land_particles = get_node_or_null(land_particles_path);
	audio_enabled = false if !land_player else true;
	particle_enabled = false if !land_particles else true;
	
func triggered() -> bool:
	return contacts.size() > 0;
	
func set_shape(shape: Shape2D):
	$CollisionShape2D.shape = shape;

func _on_GroundDetector_entered(obj):
	if not triggered() and audio_enabled:
		land_player.play_audio();
		land_particles.restart();
		land_particles.emitting = true;
	contacts.append(obj);

func _on_GroundDetector_exited(obj):
	contacts.remove(contacts.find(obj));

