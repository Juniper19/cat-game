extends CharacterBody2D
class_name Cat

@export var JUMP_MAX: int = -160; #In tutorial, JUMP_FORCE
@export var JUMP_MIN: int = -75; #In tutorial, JUMP_RELEASE_FORCE
@export var MAX_SPEED: int = 75;
@export var ACCELERATION: int = 10;
@export var FRICTION: int = 10;
@export var GRAVITY: int = 5;
@export var FALL_GRAVITY: int = 3.5; #More force on the way down
@export var MAX_GRAVITY: int = 350; #Max pull of gravity
@export var DASH_SPEED: int = 150;
@export var DASH_COUNTUP: int = 0;
@export var DASH_TIME: int = .5;

var has_key: bool = false

		##perfect command for crouch jump lol: velocity.x = move_toward(velocity.x, 0, DASH_SPEED)

func _physics_process(delta):
	apply_gravity() 
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	var moving_x = Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left")
	var moving_y = Input.is_action_just_pressed("ui_up") or not is_on_floor();
	var dashing = Input.is_physical_key_pressed(KEY_E);
	##var speaking = Input.is_physical_key_pressed(KEY_SPACE);
	
	#if(speaking):
		#DialogueManager.show_example_dialogue_balloon(load("res://mainDialogue.dialogue"), "start")
		#return
	
	if input.x == 0: #If not moving...
		apply_friction()
		if is_on_floor(): 
			if dashing:
				apply_dash(input);
			else:
				$AnimatedSprite2D.animation = "Idle"
		else:
			if dashing:
				apply_dash(input);
			else:
				$AnimatedSprite2D.animation = "Jump"
	
	else: #If we are moving...
		apply_acceleration(input.x)
		if is_on_floor():
			if dashing:
				apply_dash(input);
			else:
				$AnimatedSprite2D.animation = "Run"
		else:
			if dashing:
				apply_dash(input);
			else:
				$AnimatedSprite2D.animation = "Jump"
		$AnimatedSprite2D.flip_h = input.x < 0 #Flips when direction changes
		
	if is_on_floor(): #If we are on the floor
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_MAX;
	else: #If not on the floor
		if Input.is_action_just_released("ui_up") and velocity.y < -75:
			velocity.y = JUMP_MIN; 
		
		#Fall faster on the way down
		if velocity.y > 0:
			velocity.y += FALL_GRAVITY; 
			
	move_and_slide();
	
func apply_dash(input):
	$AnimatedSprite2D.animation = "Dash";
	$AnimatedSprite2D.flip_h = input.x < 0
	
	if input.x > 0:
		velocity.x = lerp(0, DASH_SPEED, 2);
	elif input.x < 0:
		velocity.x = lerp(0, -DASH_SPEED, 2);
	else:
		velocity.x = lerp(0, DASH_SPEED, 2);
		

func apply_gravity():
	velocity.y += GRAVITY;
	velocity.y = min(velocity.y, MAX_GRAVITY)

#Lower the number on the far right, the greater the effect
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION);
	
func _on_key_collected():
	has_key = true
	print("Got the key!")
