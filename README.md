# OdyssHey
Il s'agit d'une tentative de création de Virtual Table Top avec Godot4.

| :warning: | Ce logiciel est en cours de développement et n'est actuellement pas utilisable. |
|:----------|---------------------------------------------------------------------------------|


Ce logiciel utilise Rathole ([Lien](https://github.com/rapiz1/rathole)) ainsi que Godot 4 ([Lien](https://godotengine.org/)).


---

## Si vous êtes GM :
Vous avez déja un serveur, il vous suffit de partager le fichier de configuration avec les joueurs et tout devrait fonctionner.

Sinon, il vous faudra heberger un serveur :arrow_down: 


---

## Si vous voulez heberger un server :
Voici un tuto pour vous guider à l'installation :
##### Lier les joueur :
Afin de lier les joueurs, j'utilise Rathole qui permet d'exposer le server du Game Master aux autre joueurs

Il vous faudra donc un tout petit server (1 vcpu et 0.5 Gb de ram sufit largement) (raspberry, certaine box internet) et faire quelque config.

Voici un exemple de config du serveur rathole : **server.toml**
```toml=
[server]
bind_addr = "0.0.0.0:32000" #Ici, il faudra faire une redirection de port(tcp et udp) sur votre box/routeur 
# Vous pouvez mettre le port que vous souhaitez, essayer lors de la redirection de prendre le meme port sur la box que celui ci dessus
 
[server.services.ce_que_vous_voulez] #C'est le nom du server
type = "udp" # ! Ne pas modifier
token = "OdyssHey" # C'est le mot de passe du serveur
bind_addr = "0.0.0.0:32001" #Ici aussi il faudra faire une redirection de port mais uniquement udp

[server.services.un_second_server] 
#Vous pouvez en heberger autant que vous voulez tant que vous changer le nom du server ainsi que le port associé
type = "udp" # ! Ne pas modifier
token = "OdyssHey" # Vous n'êtes pas obligé de changer le mot de passe
bind_addr = "0.0.0.0:32002" #Ici aussi il faudra faire une redirection de port mais uniquement udp
```
| :memo:        |Je vous conseil de ne pas depasser les 5 serveurs surtout si vous avez un débit de connection assez faible  |
|---------------|:-----------------------------------------------------------------------------------------------------------|


Et voici l'un des fichiers de configuration (car on a 2 serveur, ici, c'est pour "ce_que_vous_voulez") à entrer dans HodyssHey : **config.json**

```json
{
  "serverRathole": {
    "ip": "L'ip de votre box/routeur",
    "UDPport": 32001,
    "clientPort": 32000,
    "token": "OdyssHey",
    "serviceName": "ce_que_vous_voulez"
  },
  "hosting": {
    "maxConnections": 8,
    "openPort": 32001
  }
}
```
| :exclamation:  | Nombre max de joueur pour l'instant, limité à 8 joueur par server (en incluant de GM). Il est important de prendre les mêmes port que sur la config du serveur|
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|


Petit VPS qui permet de faire tourner 4/5 serveur pour 1.20€, [ICI](https://www.ionos.fr/serveurs/vps#packages). (*Je n'ai aucune affiliation avec cette marque, je partage juste un bon plan.*)

---

## Si vous souhaitez participer au projet :
Vous êtes les bienvenu(e)s, que vous soyez graphiste, developpeur.... n'hesitez pas à me contacter via Discord Siryak#5777

---

## Si vous avez trouvé un bug, n'hesitez pas à créer une issue :smiley: 

---

# Si vous avez un soucis, envoyez moi un message sur Discord Siryak#5777
