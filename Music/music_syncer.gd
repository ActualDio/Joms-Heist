extends Node

signal begin;
signal end;
func start_music():
	emit_signal("begin");

func stop_all():
	emit_signal("end");
