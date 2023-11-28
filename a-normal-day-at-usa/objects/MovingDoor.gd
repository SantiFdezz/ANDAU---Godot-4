extends Node2D

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
				$AnimatableBody2D/Path2D/AnimationPlayer.play("door_moving")
