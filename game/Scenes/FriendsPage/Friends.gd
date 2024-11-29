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
var radio_off = preload("res://UI_Elements/RadioButtonOff.png")
var radio_on = preload("res://UI_Elements/RadioButtonOn.png")

var template_friend_item = preload("res://Scenes/FriendsPage/FriendItem.tscn")
var template_friend_skill = preload("res://Scenes/FriendsPage/FriendSkill.tscn")

#####################################
# ONREADY VARIABLES
#####################################
onready var purchase_window_background = $"%PurchaseWindowBackground"
onready var friend_name_input = $"%FriendNameInput"
onready var friend_ethnicity_option_button = $"%FriendEthnicityOptionButton"
onready var friend_profession_option_button = $"%FriendProfessionOptionButton"
onready var friend_connection_level_button = $"%FriendConnectionLevelButton"
onready var reputation_spin_box = $"%ReputationSpinBox"
onready var friend_area_information_checkbox = $"%FriendAreaInformationCheckbox"
onready var friend_seasoned_fighter_checkbox = $"%FriendSeasonedFighterCheckbox"

onready var basic_info_step = $"%BasicInfoStep"
onready var items_step = $"%ItemsStep"
onready var skills_step = $"%SkillsStep"

onready var step_list = [basic_info_step,items_step,skills_step]
onready var current_step = basic_info_step

onready var step_one_indicator = $"%StepOneIndicator"
onready var step_two_indicator = $"%StepTwoIndicator"
onready var step_three_indicator = $"%StepThreeIndicator"

onready var indicator_list = [step_one_indicator, step_two_indicator, step_three_indicator]

onready var add_item_button = $"%AddItem"
onready var add_skill_button = $"%AddSkill"

onready var item_grid = $"%ItemGrid"
onready var skill_grid = $"%SkillGrid"

#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass

func _ready() -> void:
	set_step_state()
	set_step_pips_state()


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
	current_step = basic_info_step
	set_step_state()
	set_step_pips_state()
	currently_edited_friend = Friend.new()
	currently_edited_friend.is_seasoned_fighter = false
	currently_edited_friend.is_area_information_broker = false
	friend_area_information_checkbox.pressed = false
	friend_seasoned_fighter_checkbox.pressed = false
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


func _on_FriendHireButton_pressed():
	pass # Replace with function body.


func _on_FriendCancelButton_pressed():
	purchase_window_background.visible = false
	currently_edited_friend = null
	friend_name_input.text = ""
	friend_connection_level_button.select(0)

func set_step_pips_state():
	var pip_amount = step_list.find(current_step)
	for i in range(3):
		if i <= pip_amount:
			indicator_list[i].texture = radio_on
		else:
			indicator_list[i].texture = radio_off

func set_step_state():
	for element in step_list:
		print(element)
		print(current_step)
		print(element==current_step)
		if element == current_step:
			element.visible = true
		else:
			element.visible = false
	

func _on_PreviousStep_pressed():
	var index = step_list.find(current_step)
	current_step = step_list[index-1]
	set_step_state()
	set_step_pips_state()
	


func _on_NextStep_pressed():
	var index = step_list.find(current_step)
	var next_index = 0
	if index == len(step_list)-1:
		next_index = 0
	else:
		next_index = index+1
	current_step = step_list[next_index]
	set_step_state()
	set_step_pips_state()


func _on_AddItem_pressed():
	var new_item = template_friend_item.instance()
	var item_list = DatabaseOperations.get_equipment_data()
	item_grid.add_child(new_item)
	item_grid.remove_child(add_item_button)
	item_grid.add_child(add_item_button)
	new_item.fill_option_button(item_list)


func _on_AddSkill_pressed():
	var new_skill = template_friend_skill.instance()
	skill_grid.add_child(new_skill)
	skill_grid.remove_child(add_skill_button)
	skill_grid.add_child(add_skill_button)
