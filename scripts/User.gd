extends Hand
class_name User

onready var hit_button = $UI/Hit
onready var stay_button = $UI/Stay
onready var doubledown_button = $UI/DoubleDown
onready var bet_high_button = $UI/BetHigh
onready var bet_low_button = $UI/BetLow

signal user_input(action)

func _ready():
	disable_all_buttons()
	
func disable_all_buttons():
	self.hit_button.disabled = true
	self.stay_button.disabled = true
	self.doubledown_button.disabled = true
	self.bet_high_button.disabled = true
	self.bet_low_button.disabled = true
	

	
""" SIGNALS """
func _on_Hit_pressed():
	self.doubledown_button.disabled = true
	yield(self.hit(), "completed")
	if (count_high > 21):
		pass
	
	if (count_low > 21):
		emit_signal("user_input", "user_bust")

func _on_Stay_pressed():
	emit_signal("user_input", "user_stay")

func _on_DoubleDown_pressed():
	yield(self.hit(false), "completed")
	emit_signal("user_input", "user_stay")

func _on_BetHigh_pressed():
	emit_signal("user_input", "user_bet")

func _on_BetLow_pressed():
	emit_signal("user_input", "user_bet")
