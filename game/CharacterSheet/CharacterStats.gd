extends Node

export var character_name : String
export var ethnicity : String
export var ethnicity_trait : String

export var agi_value : int
export var agi_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var per_value : int
export var per_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var cha_value : int
export var cha_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var wit_value : int
export var wit_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var bod_value : int
export var bod_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

var attribute_modifier : int
