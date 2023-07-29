extends TextureRect

func _ready():
	pivot_offset = size/2
	
	#Global.used_rand.seed = 14578 #TODO à enlever lors de la release
	
	
var nb = []


func launch_dice(val:int)  -> int:
	#NB de frame 5
	
	for i in range(6):
		nb.append(Global.used_rand.randi_range(1, val))
	launch_anim()
	return nb[5]
	

func launch_anim():
	for i in range(5):
		var visual_nb = nb[i]
		rotation_degrees = 0
		$U.hide()
		$D1.hide()
		$D2.hide()
		$C1.hide()
		$C2.hide()
		$C3.hide()
		$M1.hide()
		$M2.hide()
		$M3.hide()
		$M4.hide()
		if visual_nb < 10:
			$U.show()
			$U.text = str(visual_nb)
		elif visual_nb < 100:
			$D1.show()
			$D2.show()
			$D1.text = str(int(visual_nb/10))
			$D2.text = str(visual_nb%10)
		elif visual_nb < 1000:
			$C1.show()
			$C2.show()
			$C3.show()
			$C1.text = str(int(visual_nb/100))
			$C2.text = str(int(visual_nb/10))
			$C3.text = str(visual_nb%10)
		else:
			$M1.show()
			$M2.show()
			$M3.show()
			$M4.show()
			$M1.text = str(int(visual_nb/1000))
			$M2.text = str(int(visual_nb/100))
			$M3.text = str(int(visual_nb/10))
			$M4.text = str(visual_nb%10)
		await get_tree().create_timer(0.1).timeout
		if Time.get_ticks_usec()%2 == 0:
			if i%2 == 0:
				rotation_degrees = 2.5
			else:
				rotation_degrees = -2.5
		else:
			if i%2 == 0:
				rotation_degrees = -2.5
			else:
				rotation_degrees = 2.5
		await get_tree().create_timer(0.1).timeout
	rotation_degrees = 0
	var visual_nb = nb[5]
	$U.hide()
	$D1.hide()
	$D2.hide()
	$C1.hide()
	$C2.hide()
	$C3.hide()
	$M1.hide()
	$M2.hide()
	$M3.hide()
	$M4.hide()
	if visual_nb < 10:
		$U.show()
		$U.text = str(visual_nb)
	elif visual_nb < 100:
		$D1.show()
		$D2.show()
		$D1.text = str(int(visual_nb/10))
		$D2.text = str(visual_nb%10)
	elif visual_nb < 1000:
		$C1.show()
		$C2.show()
		$C3.show()
		$C1.text = str(int(visual_nb/100))
		$C2.text = str(int(visual_nb/10))
		$C3.text = str(visual_nb%10)
	else:
		$M1.show()
		$M2.show()
		$M3.show()
		$M4.show()
		$M1.text = str(int(visual_nb/1000))
		$M2.text = str(int(visual_nb/100))
		$M3.text = str(int(visual_nb/10))
		$M4.text = str(visual_nb%10)
