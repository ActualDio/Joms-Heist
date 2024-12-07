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
		$Y.show();
		active = true;


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$Y.hide();
		active = false;
