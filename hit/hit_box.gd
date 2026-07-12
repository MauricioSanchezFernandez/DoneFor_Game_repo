extends Area2D
class_name HitBox

@onready var damage_timer: Timer = Timer.new()

var target_hurtbox: HurtBox = null

func _ready() -> void:
	set_active(false)
	
	# tiempo entre cada hit
	damage_timer.wait_time = 0.5
	damage_timer.timeout.connect(_on_timer_timeout)
	add_child(damage_timer)

func set_active(boolean: bool):
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = not boolean

#esto es si entran originalmente en la hurtbox
func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		target_hurtbox = area
		target_hurtbox.get_damage(1)
		damage_timer.start()        # inicia un timer para que si está demasiado tiempo dentro (damage_timwaittime), sufra

func _on_area_exited(area: Area2D) -> void:
	if area == target_hurtbox:
		damage_timer.stop()     
		target_hurtbox = null    

#se repite el hit
func _on_timer_timeout() -> void:
	if is_instance_valid(target_hurtbox):
		target_hurtbox.get_damage(1)
	else:
		damage_timer.stop()
		
