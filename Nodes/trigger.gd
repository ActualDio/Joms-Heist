extends Area2D

signal on_player_entered;


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("on_player_entered");
