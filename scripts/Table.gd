extends Node2D

""" UI """
onready var center_message_label = $Control/CenterMessage

""" Players """
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
	center_message_label.visible = false
	
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
	
	center_message_label.visible = true
	center_message_label.text = "Place a Bet"

func inital_deal():
	center_message_label.visible = false
	user.disable_all_buttons()
	
	for i in range(2):
		for j in cpus:
			yield(j.hit(), "completed")
		yield(user.hit(), "completed")
		
		if (i == 0):
			yield(dealer.hit(), "completed")
		else:
			yield(dealer.hit(false), "completed")
	

	emit_signal("game_state", CPUS_TURN)
	
func cpus_turn():
	user.disable_all_buttons()
	
	for i in cpus:
		yield(i.play_turn(), "completed")
		
	
	emit_signal("game_state", USERS_TURN)
	
func users_turn():
	user.disable_all_buttons()
	user.stay_button.disabled = false
	user.hit_button.disabled = false
	user.doubledown_button.disabled = false


func dealers_turn():
	user.disable_all_buttons()
	dealer.play_turn()
	emit_signal("game_state", RESULTS)
	
func results():
	
	# if there are double downs, flip these cards
	#user.face_up()
	#for i in cpus:
	#	i.face_up()
		
	# do some sort of celebration
	yield(get_tree().create_timer(1), "timeout")
	var res = did_user_win(dealer.count_high, user.count_high, user.count_low)
	center_message_label.visible = true
	center_message_label.text = res
	yield(get_tree().create_timer(2.5), "timeout")
	center_message_label.visible = false
	
	# reset
	user.reset()
	dealer.reset()
	for i in cpus:
		i.reset()
		
	emit_signal("game_state", PLACE_BETS)
		
func did_user_win(dealer_high, user_high, user_low):
	if user_high > 21 && user_low > 21:
		return "lose"
	if dealer_high > 21:
		return "win"

	if user_high <= 21:
		if user_high > dealer_high:
			return "win"
		elif user_high == dealer_high:
			return "tie"
		else:
			return "lose"
	
	if user_low > dealer_high:
		return "win"
	elif user_low == dealer_high:
		return "tie"
	else:
		return "lose"
