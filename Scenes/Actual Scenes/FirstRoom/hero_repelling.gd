extends Sprite2D

signal finished;

func begin():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position:y", 120,1.75).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT);
	tween.tween_interval(1.0);
	tween.tween_callback(emit_signal.bind("finished"));
	tween.tween_callback(queue_free);
