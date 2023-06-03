extends Node

enum attribute {AGI,PER,CHA,WIT,BOD,ANY}
var attribute_string: Array = DatabaseOperations.read_list_of_attributes_without_any()
