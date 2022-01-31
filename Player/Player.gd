extends KinematicBody2D
class_name Player

export(float) var gravity;
export(float) var horizontal_speed;
export(float) var skin_width;
export(float) var step_delay;
export(int) var jump_buffer_msec;
export(int) var coyote_time_msec;
export(float) var jump_force;
export(int) var max_jump_msec;

var _velocity: Vector2;
var _direction: float;
var _grounded: bool;
var _jump_grounded: bool;
var _jumping: bool;
var _time_of_last_jump : int;

func _enter_tree():
	$WalkPlayer.delay = step_delay;

func _physics_process(delta):
	detect_environment();
	process_inputs();
	handle_vel_delta(delta);
	apply_movement();
	# Should have an additional method to play the current animation.
	
# Eyes
func detect_environment():
	_grounded = is_on_floor();
	_jump_grounded = $GroundDetector.triggered();
	
	
func process_inputs():
	_direction = Input.get_axis("left", "right");
	if Input.is_action_just_pressed("jump"):
		_time_of_last_jump = OS.get_ticks_msec();
	if Input.is_action_just_released("jump"): _jumping = false;
	
# Limbs
func handle_vel_delta(var delta : float):
	# X vel.
	_velocity.x = horizontal_speed * _direction;
	# Y vel.
	if _jump_grounded and OS.get_ticks_msec() - _time_of_last_jump < jump_buffer_msec:
			_jumping = true;
			_velocity.y = -jump_force;
			play_jump_anim();
	elif _grounded:
		_velocity.y = 0.0;
		toggle_walk_anim(_velocity.x != 0.0);
	else:
		if _jumping and not is_on_ceiling():
			_jumping = OS.get_ticks_msec() - _time_of_last_jump < max_jump_msec;
			_velocity.y = -jump_force;
		else:
			if is_on_ceiling():
				_velocity.y = max(_velocity.y, 0);
			_velocity.y += gravity * delta;
		toggle_walk_anim(false);
		
func apply_movement():
	var _v = move_and_slide_with_snap(_velocity, Vector2.DOWN * 4 if _grounded and not _jumping else Vector2.ZERO, Vector2.UP, true);
	
# Animation Handlers
func toggle_walk_anim(var activity: bool):
	if (activity): 
		$WalkPlayer.play_audio();
		$WalkParticles.emitting = true;
	else: 
		$WalkPlayer.stop_audio();
		$WalkParticles.emitting = false;
func play_jump_anim():
	$JumpPlayer.play_audio();
	$JumpParticles.restart();
	$JumpParticles.emitting = true;
