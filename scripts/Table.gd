extends Node2D

onready var user = $User
onready var dealer = $Dealer
var cpus = []

signal game_state(state)

enum {
	PLACE_BETS, 
	INITAL_DEAL, 
	CPUS_TURN, 
	USERS_TURN,
	DEALERS_TURN,
	RESULTS }
	
func _ready():
	for i in get_node("CPUS").get_children():
		cpus.append(i)
	
	emit_signal("game_state", PLACE_BETS)
	
""" SIGNALS """

# main game loop 
func _on_Table_game_state(state):
	match state:
		PLACE_BETS:
			place_bets()
		INITAL_DEAL:
			inital_deal()
		CPUS_TURN:
			cpus_turn()
		USERS_TURN:
			users_turn()
		DEALERS_TURN:
			dealers_turn()
		RESULTS:
			results()
	
	
func _on_User_user_input(action):
	if (action == "user_bet"):
		emit_signal("game_state", INITAL_DEAL)
		
	if (action == "user_stay"):
		emit_signal("game_state", DEALERS_TURN)
		
	if (action == "user_bust"):
		emit_signal("game_state", DEALERS_TURN)


""" HELPER FUNCS """
func place_bets():
	user.disable_all_buttons()
	user.bet_high_button.disabled = false
	user.bet_low_button.disabled = false

func inital_deal():
	user.disable_all_buttons()
	
	for i in range(2):
		for j in cpus:
			j.hit()
		user.hit()
		
		if (i == 0):
			dealer.hit()
		else:
			dealer.hit(false)
	
	print("deal out cards")
	emit_signal("game_state", CPUS_TURN)
	
func cpus_turn():
	user.disable_all_buttons()
	
	for i in cpus:
		i.play_turn()
		
	print("cpus play")
	emit_signal("game_state", USERS_TURN)
	
func users_turn():
	user.disable_all_buttons()
	user.stay_button.disabled = false
	user.hit_button.disabled = false
	print("user play")

func dealers_turn():
	user.disable_all_buttons()
	dealer.play_turn()
	
	#emit_signal("game_state", RESULTS)
	
func results():
	
	# if there are double downs, flip these cards
	user.face_up()
	for i in cpus:
		i.face_up()
		
	# do some sort of celebration
		
	# reset
	user.reset()
	dealer.reset()
	for i in cpus:
		i.reset()
		
		
