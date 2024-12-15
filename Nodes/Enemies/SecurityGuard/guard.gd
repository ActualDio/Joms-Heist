extends CharacterBody2D


const WALKSPEED = 100.0;
const RUNSPEED = 400.0;
const JUMP_VELOCITY = -300.0

var lastKnownPlayerPos : Vector2 = Vector2.ZERO;
var canSeePlayer = false;
var playerIsCaught = false;
var objectReference : Node2D;

var dir = 1;

@export var timeSpentIdle : float = 1.5;
@export var timeSpentWalking : float = 1.5;
@export var alertNessThreshold : float = 0.25;
@export var timeToResetLook : float = 0.33;

var phaseTime = 2.0;
var alertness = 0.0;

enum STATES {IDLE,WALK,ALERT,PERSUIT};

var currentState = STATES.WALK:
	set(newState):
		#Code for exiting the previous state
		match currentState:
			STATES.ALERT:
				if newState != STATES.PERSUIT:
					pass
					#$Head.rotation = 0.0;
					#$Flashlight.rotation = 0.0;
		#set the new state
		currentState = newState;
		#Code for entering the new state
		match currentState:
			STATES.IDLE:
				phaseTime = timeSpentIdle + randf_range(-0.5,0.5);
			STATES.WALK:
				if randi_range(0,8) == 5:
					turnaround();
				phaseTime = timeSpentWalking + randf_range(-0.5,0.5);
			STATES.ALERT:
				alertness = 0.0;
			STATES.PERSUIT:
				alertness = 1.5
				
func turnaround():
	scale.x *= -1;
	dir *= -1;
	position.x += dir * 2;
	
func faceSpecificDir(value):
	var newDir = sign(value);
	if newDir != dir: #If you're confused by this, go check out the docs for node2d.scale. it turns out scaling things along the x axis is fake bullshit and results in stupid stuff happening.
		scale.x *= -1;
		dir = newDir;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	match currentState:
		STATES.IDLE:
			$Head.rotation = move_toward($Head.rotation,0,delta/timeToResetLook);
			$Flashlight.rotation = move_toward($Flashlight.rotation,0,delta/timeToResetLook);
			velocity.x = velocity.x * min(delta/0.25, 1.0)
			#Sway flashlight up and down a little
			phaseTime -= delta;
			if phaseTime <= 0:
				currentState = STATES.WALK;
			pass
		STATES.WALK:
			phaseTime -= delta;
			if is_on_wall() or !$RayCast2D.is_colliding():
				turnaround();
			velocity.x = dir * WALKSPEED;
			if phaseTime <= 0:
				currentState = STATES.IDLE;
		STATES.ALERT:
			velocity.x = 0;
			if canSeePlayer:
				alertness += delta;
				lastKnownPlayerPos = objectReference.global_position;
			else:
				alertness -= delta;
			var angle_to_target = global_position.direction_to(lastKnownPlayerPos).angle();
			$Head.look_at(lastKnownPlayerPos);
			$Flashlight.look_at(lastKnownPlayerPos);
			faceSpecificDir(lastKnownPlayerPos.x - global_position.x);
			if alertness <= 0:
				currentState = STATES.IDLE;
			if alertness >= alertNessThreshold && !playerIsCaught:
				currentState = STATES.PERSUIT;
		STATES.PERSUIT:
			if canSeePlayer:
				alertness = alertNessThreshold;
				lastKnownPlayerPos = objectReference.global_position;
			else:
				alertness -= delta;
			if alertness <= 0:
				currentState = STATES.ALERT;
				alertness = alertNessThreshold - delta;
			$Head.look_at(lastKnownPlayerPos);
			$Flashlight.look_at(lastKnownPlayerPos);
			faceSpecificDir(lastKnownPlayerPos.x - global_position.x);
			velocity.x += sign(lastKnownPlayerPos.x - global_position.x) * delta * RUNSPEED * 3;
			velocity.x = clampf(velocity.x,-RUNSPEED,RUNSPEED);
			
			if (absf(lastKnownPlayerPos.x - global_position.x) < 75 || is_on_wall()) && global_position.y - 16 > lastKnownPlayerPos.y && is_on_floor():
				velocity.y += JUMP_VELOCITY;
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_spotter_player_entered(p) -> void:
	objectReference = p;
	canSeePlayer = true;
	lastKnownPlayerPos = p.global_position;
	currentState = STATES.ALERT;
	$Bang.show();

func _on_spotter_player_exited(p) -> void:
	lastKnownPlayerPos = p.global_position;
	canSeePlayer = false;
	$Bang.hide();


func _on_catching_range_body_entered(body: Node2D) -> void:
	if body is Player && canSeePlayer:
		if !playerIsCaught:
			body.triggerGameOver();
			currentState = STATES.ALERT;
			playerIsCaught = true;


func _on_catching_range_body_exited(body: Node2D) -> void:
	if body is Player && body.global_position.distance_to(self.global_position) > 100:
		currentState = STATES.WALK;
		$Head.rotation = 0;
		$Flashlight.rotation = 0;
		$Bang.hide();
		playerIsCaught = false;
