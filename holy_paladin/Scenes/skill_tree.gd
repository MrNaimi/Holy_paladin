extends Control
@onready var skill_points: Label = $Background/SkillPoints


var Skills: Dictionary = {
	"Dash":{
		"unlock":false,
		"level": 0
	},
	"+10% Attack damage":{
		"unlock": false,
		"level": 0
	},
	"Holy Projectile":{
		"unlock": false,
		"level": 0
	},
	"+5% Movement Speed":{
		"unlock": false,
		"level": 0
	},
	"+5% Health":{
		"unlock": false,
		"level": 0
	},
	"+5% Attack Damage":{
		"unlock": false,
		"level": 0
	},
	"5% Cooldown Reduction":{
		"unlock": false,
		"level": 0
	},
	"Jump":{
		"unlock": false,
		"level": 0
	},
	"10% Non-Spell Cooldown Reduction":{
		"unlock": false,
		"level": 0
	},
	"Taunt":{
		"unlock": false,
		"level": 0
	},
	"+10% Armor":{
		"unlock": false,
		"level": 0
	},
	"Holy Shield":{
		"unlock": false,
		"level": 0
	},
	"+5% Attack Damage 2":{
		"unlock": false,
		"level": 0
	},
	"+10% Health":{
		"unlock": false,
		"level": 0
	},
	"+5% Attack Damage 3":{
		"unlock": false,
		"level": 0
	},
	"+5% Spell Damage":{
		"unlock": false,
		"level": 0
	},
	"Extra Dash":{
		"unlock": false,
		"level": 0
	},
	"Taunt Buff":{
		"unlock": false,
		"level": 0
	},
	"Holy Shield Buff":{
		"unlock": false,
		"level": 0
	},
	"Leap":{
		"unlock": false,
		"level": 0
	},
	"Spin":{
		"unlock": false,
		"level": 0
	},
	"AoE":{
		"unlock": false,
		"level": 0
	},
	
}

func _process(delta: float) -> void:
	skill_points.text = "Skillpoints left: "+str(GlobalVariables.skillpoints)

func setUnlock(skill: String, level: int):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = true
		Skills[skill]["level"] = level

func setLock(skill: String):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = false

func checkSkill(skill: String) -> bool:
	return Skills[skill]["unlock"]
