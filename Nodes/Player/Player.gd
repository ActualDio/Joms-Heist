extends CharacterBody2D
class_name Player #This way it'll be a lot easier to tell if something is a player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var crouching = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action_pressed("crouch"):
		crouching = true;
	if event.is_action_released("crouch"):
		crouching = false;

func _physics_process(delta):
	#Update Animations
	
	
	
	
	#Vertical Speed Stuff
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Horizontal Speed Stuff
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * (1 - (0.5 * float(crouching)));
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
	
	#Move and Slide
	move_and_slide()
