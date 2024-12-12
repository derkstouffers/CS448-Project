"""
	fireball object
	
	registers direction character is facing and flips animation based on direction
	gives attack motion
	
	registers if attack interacts with slime enemy FUTURE WORK add more enemies and interactiveness
"""

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
		
		queue_free()


	$fireAttackAnimation.play("explosion")
	await $fireAttackAnimation.animation_finished
	queue_free()
