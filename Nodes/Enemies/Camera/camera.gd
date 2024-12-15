extends Node2D

@export var moving = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if moving:
		$Main/CameraMotion.play("CameraMotion");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spotter_player_entered(p: Node2D) -> void:
	p.triggerGameOver();
	$Main/Spotlight2.color = Color.RED;
	#$Bang.show();


func _on_spotter_player_exited(player: Variant) -> void:
	$Main/Spotlight2.color = Color.WHITE;
