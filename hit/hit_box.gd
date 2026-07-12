extends Area2D
class_name HitBox

@onready var damage_timer: Timer = Timer.new()
var target_hurtbox: HurtBox = null

#ponemos un timer para que, si la hitbox está dentro de la hurtbox, cada cierto tiempo sufra daño

func _ready() -> void:
	set_active(false)
	
	damage_timer.wait_time = 0.5 #digamos 0,5 sdegundos
	damage_timer.timeout.connect(_on_timer_timeout) #función del final que gestiona lo que ocurre al llegar a 0
	add_child(damage_timer)
	
	#gestión de hijos de "HurtBox". es redudante aquí porque solo hay collisionshapes
	#pero como actua como template, lo dejamos en caso de que en un futuro se necesite meter de hijo algo que
	#no sea un collision shape (por ejemplo animaciones específicas relacionadas)

func set_active(boolean: bool):
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = not boolean
	
	if not boolean:
		damage_timer.stop()
		target_hurtbox = null
		
	#hitbox entrando en hurtbox

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		target_hurtbox = area
		target_hurtbox.get_damage(1) #daño recibido
		damage_timer.start()     #iniciamos el timer
		
	#timer llega a 0

func _on_timer_timeout() -> void:
	if is_instance_valid(target_hurtbox) and has_overlapping_areas(): #comprueba si la hitbox sigue en la hurtbox (overlap)
		if target_hurtbox in get_overlapping_areas():
			target_hurtbox.get_damage(1)
			return #hace daño y vuelve a empezar
	
	
	damage_timer.stop()   #en caso de que ya no haya nada, el timer se para
	target_hurtbox = null
