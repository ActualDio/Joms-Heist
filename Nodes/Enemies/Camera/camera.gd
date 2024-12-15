extends Node2D

@export var moving = false;

@export_enum("180","135","90","45","0") var angle = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if moving:
		match angle:
			0:
				$Main/CameraMotion.play("180DegreeArc");
			1:
				$Main/CameraMotion.play("135DegreeArc")
			2:
				$Main/CameraMotion.play("90DegreeArc")
			3:
				$Main/CameraMotion.play("45DegreeArc")
			4:
				$Main/CameraMotion.play("default");
		
	else:
		$Main/CameraMotion.play("default");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spotter_player_entered(p: Node2D) -> void:
	p.triggerGameOver();
	$Main/Spotlight2.color = Color.RED;
	#$Main/CameraMotion.pause();
	#$Bang.show();


func _on_spotter_player_exited(player: Variant) -> void:
	$Main/Spotlight2.color = Color.WHITE;
	#$Main/CameraMotion.play();
