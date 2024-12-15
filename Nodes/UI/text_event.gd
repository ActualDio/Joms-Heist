extends Control

signal finished

@export_multiline var dialog : String;

@export_range(0.01,0.15) var delay_between_chars : float = 0.04;

@onready var textLabel : RichTextLabel = $Textbox/TextContent;

@onready var charLabel : Label = $CharacterTitle/Label;

@onready var dialogArray : PackedStringArray = dialog.rsplit("\n");

@onready var countDown : float = delay_between_chars;

var currentLine = 0;

var started = false; #turns true when the beginEvent function is called. used to ensure this function is not called multiple times.
var active = false; #turns true when the textbox is able to recieve input.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dialogArray[0].begins_with(">"): #if the first line denotes a character... (this should usually be the case)
		charLabel.text = dialogArray[0].lstrip(">");
		currentLine += 1;
	hide();

func beginEvent(_unused = null):
	print("Twice!")
	if !started:
		started = true;
		get_tree().paused = true;
		$AnimationPlayer.play("In");
		textLabel.text = "";
		textLabel.visible_characters = 0;
		show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		#print("Chars Visible: " + str(textLabel.visible_characters) + "\nTotal Chars: " + str(textLabel.get_total_character_count()));
		if textLabel.visible_characters < textLabel.get_total_character_count():
			countDown -= delta;
			if countDown <= 0:
				textLabel.visible_characters += 1;
				if textLabel.text[textLabel.visible_characters - 1] != " ":
					if charLabel.text == "P":
						$PSoundPlayer.play();
					elif charLabel.text == "Robotic Voice":
						$robonoise.play();
					else:
						$TextSoundPlayer.play();
				countDown += delay_between_chars;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TextAdvance"):
		if active:
			if textLabel.visible_characters == textLabel.get_total_character_count():
				currentLine += 1;
				if currentLine >= dialogArray.size():
					$AnimationPlayer.play("Out");
					active = false;
				else:
					updateText();
			else:
				textLabel.visible_characters = textLabel.get_total_character_count();

func updateText():
	if dialogArray[currentLine].begins_with(">"):
		charLabel.text = dialogArray[currentLine].lstrip(">");
		currentLine += 1;
	textLabel.text = dialogArray[currentLine];
	textLabel.visible_characters = 0;

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Out":
		get_tree().paused = false;
		hide();
		emit_signal("finished");
		currentLine = 0;
		started = false;
		if dialogArray[0].begins_with(">"): #if the first line denotes a character... (this should usually be the case)
			charLabel.text = dialogArray[0].lstrip(">");
			currentLine += 1;
	elif anim_name == "In":
		active = true;
		updateText();
		
