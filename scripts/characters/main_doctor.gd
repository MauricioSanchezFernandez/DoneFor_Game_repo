extends CharacterBody2D
@onready var animsprite: AnimatedSprite2D = $AM_main/AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var walk = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not is_on_floor() and velocity.y < 0:
		animsprite.animation = "jump"
	if not is_on_floor() and velocity.y > 0:
		animsprite.animation = "fall1"
	
	if velocity.x == velocity.y and velocity.x == 0 and walk == false and is_on_floor():
		animsprite.animation = "idle1"
	
	if velocity.x != 0 and animsprite.animation != "walk1" and is_on_floor():
		animsprite.animation = "walk1"
		walk = true
		
	if velocity.x == 0 and velocity.x == velocity.y and walk and is_on_floor():
		walk = false
		animsprite.animation = "stop1"
		await animsprite.animation_finished
		animsprite.animation = "walk1"
		
		
		#Falta hacer un toggle que active una variable de "ataque", donde el médico tenga el farolillo fuera por un tiempo,
		# cambiando las animaciones. Es añadir una variable y meter un "and" más, no pasa na
		
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animsprite.flip_h = false
	elif direction == -1.0:
		animsprite.flip_h = true
