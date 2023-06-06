class_name User

extends Node

var Pseudo:String
var ID:int
var PV:int
var PVMax:int
var ARM:int
var ARMMax:int
var ATK:int
var XP: int
var Level:int = 1
#Penser à ajouter les truc la Dext/Force....
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
	
func getLevel() -> int:
	return Level

func LevelUp() -> void:
	Level += 1

func setPV(ret:int) -> void:
	PV = ret
	
func getPV() -> int:
	return PV

func addPV(value:int) -> void:
	PV += value
	
func removePV(value:int) -> void:
	PV -= value

func setPVMax(ret:int) -> void:
	PVMax = ret

func getPVMax() -> int:
	return PVMax

func setARM(ret:int) -> void:
	ARM = ret

func getARM() -> int:
	return ARM

func setARMMax(ret:int) -> void:
	ARMMax = ret

func getARMMax() -> int:
	return ARMMax

func setATK(ret:int) -> void:
	ATK = ret

func getATK() -> int:
	return ATK

func addATK(value:int) -> void:
	ATK += value
	
func removeATK(value:int) -> void:
	ATK -= value
