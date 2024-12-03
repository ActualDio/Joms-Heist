extends Node2D
@export var smiley : Sprite2D;
@export var frowney: Sprite2D;

func showSmiley():
	smiley.show()
	frowney.hide();

func showFrowney():
	frowney.show();
	smiley.hide();
