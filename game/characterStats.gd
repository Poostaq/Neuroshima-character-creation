extends Resource

class_name CharacterStats

export var Name : String
export var Ethnicity : String
export var EthnicityTrait : String

export var agiValue : int
var agiModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var perValue : int
var perModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var chaValue : int
var chaModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var witValue : int
var witModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var bodValue : int
var bodModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}
