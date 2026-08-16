extends CharacterBody2D

@onready var animsprite: AnimatedSprite2D = $AM_main/AnimatedSprite2D
@onready var hit_box: HitBox = $Pivot/hit_box

const SPEED = 400.0
const JUMP_VELOCITY = -450.0

const DASH_SPEED = 900.0       
const DASH_DURATION = 0.25     
const DASH_COOLDOWN = 0.35    

@export var life: int = 8
@export var knockback_force: float = 450.0
@export var invincibility_duration: float = 1.0

var is_dead: bool = false
var is_invincible: bool = false
var is_in_knockback: bool = false

var walk = false
var lantern = false
var is_attacking = false

var is_dashing = false         
var end_dashing = false    
var can_dash = true           
var dash_direction = 1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if SceneManager.leftRight == false:
		global_position.x = SceneManager.pos_scenesRight_x[SceneManager.actualScene]
		global_position.y = SceneManager.pos_scenesRight_y[SceneManager.actualScene]
	else: 
		global_position.x = SceneManager.pos_scenesLeft_x[SceneManager.actualScene]
		global_position.y = SceneManager.pos_scenesLeft_y[SceneManager.actualScene]

func _physics_process(delta: float) -> void:
	#BLOQUEAR SI MUERTO
	if is_dead:
		velocity.x = 0
		if not is_on_floor():
			velocity.y += gravity * delta
			move_and_slide()
		return

	# knockback
	if is_in_knockback:
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		check_enemy_collisions()
		return

	# dash
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0 
		move_and_slide()
		check_enemy_collisions()
		return
		
	if end_dashing:
		velocity.x = velocity.x * 0.9
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		check_enemy_collisions()
		return
		
	# atacar
	if is_attacking:
		velocity.x = 0
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		check_enemy_collisions()
		return

	# gravedad de normal
	if not is_on_floor():
		velocity.y += gravity * delta

	# habilidades (ataque, dash)
	if Input.is_action_just_pressed("ui_dash") and can_dash:
		start_dash()
		return 
	
	if Input.is_action_just_pressed("ui_attack") and is_on_floor():
		is_attacking = true
		if not lantern:
			lantern = true
			animsprite.play("attack", 2.5)
		else:
			lantern = false
			animsprite.play("attack_end", 2.5)
			
		await animsprite.animation_finished
		is_attacking = false
		return 

	# mov en x
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

	# salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# animaciones (no todas)
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
	check_enemy_collisions()

# daño, knockback y muerte

func check_enemy_collisions() -> void:
	if is_dead:
		return

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("enemies"):
			# Enviamos la normal de colisión (apunta fuera del enemigo hacia el jugador)
			take_damage(1, collision.get_normal())

func take_damage(amount: int, normal: Vector2) -> void:
	if is_invincible or is_dead:
		return

	life -= amount
	print("Vida restante: ", life)

	if life <= 0:
		die()
		return

	# La X de la normal siempre apunta hacia el lado donde está el jugador respecto al choque
	var dir_x = sign(normal.x)

	# Si el choque fue 100% vertical (caíste justo encima), empuja hacia atrás según hacia dónde mira
	if dir_x == 0:
		dir_x = 1.0 if animsprite.flip_h else -1.0

	velocity.x = dir_x * knockback_force
	velocity.y = -knockback_force * 0.4

	is_in_knockback = true
	get_tree().create_timer(0.2).timeout.connect(func(): is_in_knockback = false)

	trigger_invincibility()

func trigger_invincibility() -> void:
	is_invincible = true

	var tween = create_tween().set_loops(int(invincibility_duration / 0.2))
	tween.tween_property(animsprite, "modulate:a", 0.2, 0.1)
	tween.tween_property(animsprite, "modulate:a", 1.0, 0.1)

	await get_tree().create_timer(invincibility_duration).timeout

	is_invincible = false
	animsprite.modulate.a = 1.0

func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	is_dashing = false
	end_dashing = false
	is_attacking = false
	is_in_knockback = false

	if hit_box:
		hit_box.set_active(false)

	animsprite.play("death")
	await animsprite.animation_finished
	animsprite.pause()

# mas animaciones y habilidades

func start_dash() -> void:
	if is_dead: return
	is_dashing = true
	can_dash = false
	
	animsprite.play("dash") 

	await get_tree().create_timer(DASH_DURATION).timeout
	if is_dead: return
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

func _on_animated_sprite_2d_frame_changed() -> void:
	if not animsprite or is_dead: return
	
	var attackAnims = ["walk2", "idle2", "attackhold", "fall2", "stop2"]
	
	if animsprite.animation in attackAnims:
		hit_box.set_active(true)
	else:
		hit_box.set_active(false)
