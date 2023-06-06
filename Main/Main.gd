extends Node

var Profile = preload("res://Main/User/Profile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)
	if !multiplayer.is_server():
		$Lobby/LobbyLayer/MainMenu/MarginContainer/VBoxContainer/Button.set_disabled(true)
	update_list_player(var_to_str(Global.liste_joueur))

func _player_connected(_id):
	pass
	# Called on both clients and server when a peer connects. Send my info to it.


func _player_disconnected(id):
	if multiplayer.is_server():
		Global.remove_user_from_ID(id)
		rpc("update_list_player",var_to_str(Global.liste_joueur))
	pass

func _connected_ok():
	rpc("register_player", Global.pseudo)

func _server_disconnected():
	pass

func _connected_fail():
	pass # Could not even connect to server; abort.

@rpc("any_peer")
func register_player(info):
	if multiplayer.is_server():
		# Store the info
		var registerUser = User.new(multiplayer.get_remote_sender_id())
		registerUser.setPseudo(str(info))
		Global.liste_joueur.append(registerUser)
		rpc("update_list_player",var_to_str(Global.liste_joueur))
	
@rpc("call_local")
func update_list_player(list):
	var List = str_to_var(list)
	for elem in $Lobby/LobbyLayer/MainMenu/MarginContainer/VBoxContainer/VBoxContainer.get_children():
		elem.queue_free()
	for elem in List:
		var user = Profile.instantiate()
		user.set("metadata/peer_id",elem.getID())
		user.get_child(0).text = "  " + elem.getPseudo()
		user.connect("kick", kickplayer)
		if multiplayer.is_server():
			if user.get("metadata/peer_id") != 1:
				user.get_child(1).show()
		$Lobby/LobbyLayer/MainMenu/MarginContainer/VBoxContainer/VBoxContainer.add_child(user)
	

func kickplayer(id:int):
	rpc_id(id,"get_kicked")

@rpc
func get_kicked():
	multiplayer.multiplayer_peer = null
	OS.alert("Vous avez été exclus")
	get_tree().change_scene_to_file("res://Host_or_Connect/Host_or_Connect.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	if Global.liste_joueur.size() < 2:
		OS.alert("Il vous faut au moins 2 joueurs pour commencer la partie.")
		return
	$VTT/VTTLayer/PanelContainer.show()
	Global.peer.set_refuse_new_connections(false)
	rpc("display_vtt")
	
	
@rpc("call_local")
func display_vtt():
	$Lobby/LobbyLayer.hide()
	$VTT/VTTLayer.show()
