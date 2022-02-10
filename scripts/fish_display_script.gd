extends Node2D

func _ready():

	var timer = get_node("Timer")
	timer.set_wait_time( 1.75 )
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()

func _on_Timer_timeout():
	get_tree().quit()
