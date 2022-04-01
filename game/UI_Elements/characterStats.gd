extends Resource

class_name CharacterStats

export var Name : String
export var Ethnicity : String
export var EthnicityTrait : String

export var agiValue : int
export var agiModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var perValue : int
export var perModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var chaValue : int
export var chaModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var witValue : int
export var witModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var bodValue : int
export var bodModifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}
