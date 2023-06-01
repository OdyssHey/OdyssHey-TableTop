class_name User

extends Node

var Pseudo:String
var ID:int
var XP: int
var Level:int
#Si ajout de nouvelle var, pensser à l'add dans le constructeur

func _init(id:int = -1,profile:User = null):
	ID = id
	if profile != null:
		Pseudo = profile.getPseudo()
		#Ajouter ici si nouvelle var

func getID() -> int:
	return ID

func setPseudo(pseudo:String) -> void:
	Pseudo = pseudo
	
func getPseudo() -> String:
	return Pseudo

func addXP(value:int) -> void:
	XP += value

func removeXP(value:int) -> void:
	XP -= value
	
func getXP() -> int:
	return XP

func setXP(value:int) -> void:
	XP = value
	
 
