extends CharacterBody2D
@onready var animsprite: AnimatedSprite2D = $AM_main/AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_SPEED = 800.0       
const DASH_DURATION = 0.2     
const DASH_COOLDOWN = 0.75     

var walk = false
var lantern = false
var is_attacking = false

var is_dashing = false         
var end_dashing = false    
var can_dash = true           
var dash_direction = 1.0       

func _physics_process(delta: float) -> void:
	
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta

	#EL VERDADERO DASH
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0 
		move_and_slide()
		return
		
	if end_dashing:
		velocity.x = velocity.x * 0.9
		move_and_slide()
		return
		
	#EL VERDADERO ATAQUE
	if is_attacking:
		velocity.x = 0
		move_and_slide()
		return
		


	if Input.is_action_just_pressed("ui_dash") and can_dash:
		start_dash()
		return 
	
	"""
	"ATAQUE":
		Reproduce animaciones
		Espera
		Y cambia bools de valor
		(El verdadero ATAQUE está al principio del physics void)
	"""
	if Input.is_action_just_pressed("ui_attack") and is_on_floor():
		is_attacking = true
		if not lantern:
			lantern = true
			animsprite.play("attack")
		else:
			lantern = false
			animsprite.play("attack_end")
			
		await animsprite.animation_finished
		is_attacking = false
		return 
	
	#EL VERDADERO MOVIMIENTO
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		walk = true
		dash_direction = sign(direction) 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walk = false

	if direction == 1.0:
		animsprite.flip_h = false
	elif direction == -1.0:
		animsprite.flip_h = true

	if direction == 0:
		dash_direction = -1.0 if animsprite.flip_h else 1.0

	#SALTO
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if not is_on_floor():
		if velocity.y < 0:
			animsprite.play("jump")
		else:
			animsprite.play("fall2" if lantern else "fall1")
	else:
		if walk:
			animsprite.play("walk2" if lantern else "walk1")
		else:
			animsprite.play("idle2" if lantern else "idle1")

	move_and_slide()


"""
DASH:
	Reproduce animaciones
	Espera
	Y cambia bools de valor
	(El verdadero DASH está al principio del physics void)
"""
func start_dash() -> void:
	is_dashing = true
	can_dash = false
	
	animsprite.play("dash") 

	await get_tree().create_timer(DASH_DURATION).timeout
	is_dashing = false
	
	end_dashing = true
	
	if lantern:
		animsprite.play("stop2")
	else:
		animsprite.play("stop1")
		
	await animsprite.animation_finished 
	
	end_dashing = false 

	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true
