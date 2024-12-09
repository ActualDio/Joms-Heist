extends CharacterBody2D
class_name Player #This way it'll be a lot easier to tell if something is a player

const SPEED = 250.0
const JUMP_VELOCITY = -450.0

var crouching = false;

var caught = false;

var respawnPoint : Vector2 = Vector2(120,120);

var bufferUncrouch = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	hide();
	process_mode = ProcessMode.PROCESS_MODE_DISABLED;
	
func spawnPlayer():
	show();
	process_mode = ProcessMode.PROCESS_MODE_INHERIT;

func crouch():
	bufferUncrouch = false;
	crouching = true;
	$MainSprite.hide();
	$CrouchSprite.show();
	$MainCollisionShape.shape.size.y = 24;
	$MainCollisionShape.position.y = 11;


func uncrouch():
	crouching = false;
	$MainSprite.show();
	$CrouchSprite.hide();
	$MainCollisionShape.shape.size.y = 49;
	$MainCollisionShape.position.y = 0.5;
	

func _input(event):
	if event.is_action_pressed("crouch") && is_on_floor() && !caught:
		crouch();
	if event.is_action_released("crouch"):
		if !$CeilingDetector.is_colliding():
			uncrouch();
		else:
			bufferUncrouch = true;
	if event.is_action_pressed("interact") && caught:
		caught = false;
		position = respawnPoint;
		$AnimationPlayer.play("default");
		$CaughtText.hide();

func triggerGameOver():
	uncrouch();
	caught = true;
	velocity = Vector2.ZERO;
	$AnimationPlayer.play("Caught");
	$CaughtText.show();
	

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	#Update Animations
	if !caught:
		if is_on_floor():
			if direction:
				if direction > 0:
					$AnimationPlayer.play("walkingRight");
				else:
					$AnimationPlayer.play("walkingLeft");
			else:
				$AnimationPlayer.play("default");
	
	
	#Vertical Speed Stuff
	if not is_on_floor():
		velocity.y += gravity * delta
	if !caught:
		if bufferUncrouch && !$CeilingDetector.is_colliding():
			uncrouch();
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			if !$CeilingDetector.is_colliding():
				uncrouch();
				velocity.y += JUMP_VELOCITY
				if direction:
					if direction > 0:
						$AnimationPlayer.play("Jump_Right")
					else:
						$AnimationPlayer.play("Jump_Left")
				elif $MainSprite.flip_h:
					$AnimationPlayer.play("Jump_Left")
				else:
					$AnimationPlayer.play("Jump_Right")
		#Horizontal Speed Stuff
		if direction:
			velocity.x = direction * SPEED * (1 - (0.2 * float(crouching)));
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED);
		
		
		
	#Move and Slide
	move_and_slide()
