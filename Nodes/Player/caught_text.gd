extends Control

var countdown = 0.03;

var active = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func activate():
	$TextContent.visible_characters = 0;
	active = true;

func deactivate():
	active = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var textLabel = $TextContent;
	if active:
		if textLabel.visible_characters < textLabel.get_total_character_count():
			countdown -= delta;
			if countdown <= 0:
				countdown += 0.03;
				textLabel.visible_characters += 1;
				if textLabel.text[textLabel.visible_characters - 1] != " ":
					$TextSoundPlayer.play();
