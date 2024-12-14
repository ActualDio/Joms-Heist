extends Node2D

signal interacted

var active = false;

func _ready() -> void:
	$Y.hide();

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if active:
			emit_signal("interacted",position);
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$RadioOn.show()
		$Radio.hide()
		$Y.show();
		active = true;
		body.respawnPoint = global_position;


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$Y.hide();
		$RadioOn.hide()
		$Radio.show();
		active = false;
