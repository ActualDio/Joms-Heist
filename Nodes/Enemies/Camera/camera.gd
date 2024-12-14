extends Node2D

signal player_entered(player)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_child("CameraMotion").play("CameraMotion");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spotter_player_entered(p: Node2D) -> void:
	emit_signal("player_entered", p)
	$Bang.show();
