extends Label

var clock : float = 0.0;

@export var autoStart = false;

var sixtyMult = 1.0/60.0;

var active = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if autoStart:
		start();

func start():
	active = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		clock += delta;
		var ms = floori(clock*100.0) % 100;
		var s = floori(clock) % 60;
		var m = floori(clock*sixtyMult) % 60
		var h = floori(clock*sixtyMult*sixtyMult)
		text = str(h).pad_zeros(2) + ":" + str(m).pad_zeros(2) + ":" + str(s).pad_zeros(2) + ":" + str(ms).pad_zeros(2);
	


func _on_button_toggled(toggled_on: bool) -> void:
	print(toggled_on);
	if toggled_on:
		show();
	else:
		hide();
