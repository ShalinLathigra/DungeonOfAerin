extends KinematicBody2D
class_name Player

export(String, FILE) var next;

export(float) var walk_anim_tolerance;
export(float) var gravity;
export(float) var horizontal_speed;
export(float) var walk_particle_cutoff;
export(float) var horizontal_ramp_modifier;
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
var _dead: bool;

func _enter_tree():
	$WalkPlayer.delay = step_delay;

func _physics_process(delta):
	if not _dead:
		detect_environment();
		process_inputs();
	else:
		_direction = 0
	handle_vel_delta(delta);
	apply_movement();
	if not _dead:
		process_animation();
	# Should have an additional method to play the current animation.
	
# Eyes
func detect_environment():
	_grounded = is_on_floor();
	_jump_grounded = $GroundDetector.triggered();
	
	
func process_inputs():
	_direction = Input.get_axis("left", "right");
	if Input.is_action_just_pressed("jump") and not Input.is_action_pressed("down"):
		_time_of_last_jump = OS.get_ticks_msec();
	if Input.is_action_just_released("jump"): _jumping = false;
	
# Limbs
func handle_vel_delta(var delta : float):
	# X vel.
	var desired_velocity_x = horizontal_speed * _direction;
	# Y vel.
	if _jump_grounded and OS.get_ticks_msec() - _time_of_last_jump < jump_buffer_msec:
		desired_velocity_x += get_floor_velocity().x;
		_jumping = true;
		_velocity.y = -jump_force;
		play_jump_effects();
	elif _grounded:
		_velocity.y = 0.0;
		toggle_walk_effects(abs(_velocity.x) > walk_particle_cutoff);
	else:
		if _jumping and not is_on_ceiling():
			_jumping = OS.get_ticks_msec() - _time_of_last_jump < max_jump_msec;
			_velocity.y = -jump_force;
		else:
			if is_on_ceiling():
				_velocity.y = max(_velocity.y, 0);
			_velocity.y += gravity * delta;
		toggle_walk_effects(false);
		
	_velocity.x = lerp(_velocity.x, desired_velocity_x, delta * horizontal_ramp_modifier)
		
func apply_movement():
	var _v = move_and_slide_with_snap(_velocity, Vector2.DOWN * 4 if _grounded and not _jumping else Vector2.ZERO, Vector2.UP, true);
	
# Animation Handlers
func process_animation():
	# have to deal with idle, move, jump, fall
	# basically, gonna base anim off vel. if x > tolerance or < tolerance, set anim + direction, else Just set idle anims
	if _velocity.x > walk_anim_tolerance:
		$Sprite.play("Run")
		$Sprite.flip_h = false
	elif _velocity.x < -walk_anim_tolerance:
		$Sprite.play("Run")
		$Sprite.flip_h = true
	else:
		$Sprite.play("Idle")
	if not is_on_floor():
		if _velocity.y > 0:
			$Sprite.play("Fall")
		else:
			$Sprite.play("Jump")
		
func toggle_walk_effects(var activity: bool):
	if (activity):
		$WalkPlayer.play_audio();
		$WalkParticles.emitting = true;
	else:
		$WalkPlayer.stop_audio();
		$WalkParticles.emitting = false;
func play_jump_effects():
	$JumpPlayer.play_audio();
	$JumpParticles.restart();
	$JumpParticles.emitting = true;

# Hit detection
func _on_DamageDetector_area_entered(_area: Area2D):
	_dead = true
	$Sprite.play("Death")
	$AnimationPlayer.play("Death")
	$HurtPlayer.play_audio(true)
	
func die():
	PlayerData.reset()
	SceneLoader.goto_scene(next)
