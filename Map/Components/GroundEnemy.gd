extends KinematicBody2D
class_name GroundEnemy

export(float) var gravity;
export(float) var horizontal_speed;
export(float) var walk_particle_cutoff;
export(float) var horizontal_ramp_modifier;
export(float) var skin_width;
export(float) var step_delay;

export(Vector2) var _velocity;
var _direction: float;
var _jump_grounded: bool;
var _jumping: bool;
var _time_of_last_jump : int;
var _dead: bool;

func _enter_tree():
	$WalkPlayer.delay = step_delay;

func _physics_process(delta):
	if not _dead:
		process_senses();
	else:
		_direction = 0
	handle_vel_delta(delta);
	apply_movement();
	if not _dead:
		process_animation();
	# Should have an additional method to play the current animation.
	
func process_senses():
	var turn_around = is_on_wall() or not $GroundDetector.triggered()
	if turn_around:
		_velocity.x *= -1;
	
# Limbs
func handle_vel_delta(var delta : float):
	# Y vel.
	if is_on_floor():
		_velocity.y = 0.0;
		toggle_walk_effects(abs(_velocity.x) > walk_particle_cutoff);
	else:
		_velocity.y += gravity * delta;
		toggle_walk_effects(false);
		
func apply_movement():
	var _v = move_and_slide_with_snap(_velocity, Vector2.DOWN * 4, Vector2.UP, true);
	
# Animation Handlers
func process_animation():
	# have to deal with idle, move, jump, fall
	# basically, gonna base anim off vel. if x > tolerance or < tolerance, set anim + direction, else Just set idle anims
	if _velocity.x > 0:
		$Sprite.play("Run")
		$Sprite.scale.x = 1
		$GroundDetector.position.x = 22
	elif _velocity.x < 0:
		$Sprite.play("Run")
		$Sprite.scale.x = -1
		$GroundDetector.position.x = -22
	else:
		$Sprite.play("Idle")

func toggle_walk_effects(var activity: bool):
	if (activity):
		$WalkPlayer.play_audio();
		$WalkParticles.emitting = true;
	else:
		$WalkPlayer.stop_audio();
		$WalkParticles.emitting = false;
