extends Area2D

var speed = 180
@export var direction = 1
	
func _physics_process(delta: float) -> void:

	if direction > 0:
		$fireAttackAnimation.flip_h = false
	if direction < 0:
		$fireAttackAnimation.flip_h = true
	position.x += speed * direction * delta
		


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("slime"):
		$fireAttackAnimation.play("explosion")
		await $fireAttackAnimation.animation_finished
		#await get_tree().create_timer(0.5).timeout
		queue_free()

	#await get_tree().create_timer(1).timeout
	$fireAttackAnimation.play("explosion")
	await $fireAttackAnimation.animation_finished
	queue_free()
	#pass # Replace with function body.
