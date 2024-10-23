extends Area2D

var speed = 100
@export var direction = 1
	
func _physics_process(delta: float) -> void:
		position.x += speed * direction * delta
		


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("slime"):
		$fireAttackAnimation.play("explosion")
		await get_tree().create_timer(0.5).timeout
		queue_free()
	pass # Replace with function body.
