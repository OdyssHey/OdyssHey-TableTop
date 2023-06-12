extends Node2D

func _ready():
	Global.used_rand.seed = 14578
	launch_anim(3)

func launch_dice(val:int) -> int:
	if val < 10:
		pass
	elif val < 100:
		pass
	elif val < 1000:
		pass
	
	
	return 0
	
func launch_anim(val:int):
	#NB de frame 5
	if val < 10:
		$Sprite2D/U.show()
		for i in range(5):
			$Sprite2D/U.text = str(Global.used_rand.randi_range(1, val))
	elif val < 100:
		pass
	elif val < 1000:
		pass
