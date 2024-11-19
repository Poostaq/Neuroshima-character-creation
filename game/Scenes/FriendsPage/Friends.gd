extends Node


#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################

#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var currently_edited_friend: Friend
#####################################
# ONREADY VARIABLES
#####################################
onready var purchase_window_background = $"%PurchaseWindowBackground"
onready var friend_ethnicity_option_button = $"%FriendEthnicityOptionButton"
onready var friend_profession_option_button = $"%FriendProfessionOptionButton"
onready var friend_connection_level_button = $"%FriendConnectionLevelButton"
onready var reputation_spin_box = $"%ReputationSpinBox"
onready var friend_area_information_checkbox = $"%FriendAreaInformationCheckbox"
onready var friend_seasoned_fighter_checkbox = $"%FriendSeasonedFighterCheckbox"

#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################


func _on_AddFriendButton_pressed():
	purchase_window_background.visible = true
	currently_edited_friend = Friend.new()
	currently_edited_friend.is_seasoned_fighter = false
	currently_edited_friend.is_area_information_broker = false
	currently_edited_friend.connection_level = friend_connection_level_button.get_item_text(friend_connection_level_button.selected)


func _on_FriendNameInput_text_changed(new_text):
	currently_edited_friend.friend_name = new_text


func _on_FriendEthnicityOptionButton_item_selected(index):
	currently_edited_friend.ethnicity = friend_ethnicity_option_button.get_item_text(index)


func _on_FriendProfessionOptionButton_item_selected(index):
	currently_edited_friend.profession = friend_profession_option_button.get_item_text(index)


func _on_FriendConnectionLevelButton_item_selected(index):
	currently_edited_friend.connection_level = friend_connection_level_button.get_item_text(index)


func _on_ReputationSpinBox_value_changed(value):
	currently_edited_friend.reputation = value


func _on_FriendAreaInformationCheckbox_toggled(button_pressed):
	currently_edited_friend.is_area_information_broker = button_pressed


func _on_FriendSeasonedFighterCheckbox_toggled(button_pressed):
	currently_edited_friend.is_seasoned_fighter = button_pressed
