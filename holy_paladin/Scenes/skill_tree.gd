extends Control
@onready var skill_points: Label = $Background/SkillPoints

var Skills: Dictionary = {
	"Dash":{
		"unlock":false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon35.png")
	},
	"+10% Attack damage":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Holy Projectile":{
		"unlock": false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon14.png")
	},
	"+5% Movement Speed":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"+5% Health":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"+5% Attack Damage":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"5% Cooldown Reduction":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Jump":{
		"unlock": false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon27.png")
	},
	"10% Non-Spell Cooldown Reduction":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Heal":{
		"unlock": false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon26.png")
	},
	"+10% Armor":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Holy Shield":{
		"unlock": false,
		"level": 0,
		"ability": true
	},
	"+5% Attack Damage 2":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"+10% Health":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"+5% Attack Damage 3":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"+5% Spell Damage":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Extra Dash":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Taunt Buff":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Holy Shield Buff":{
		"unlock": false,
		"level": 0,
		"ability": false
	},
	"Leap":{
		"unlock": false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon30.png")
	},
	"Spin":{
		"unlock": false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon29.png")
	},
	"AoE":{
		"unlock": false,
		"level": 0,
		"ability": true,
		"texture": preload("res://assets/ui_assets/paladin_icons/Icon22.png")
	},
	
}

func _process(delta: float) -> void:
	skill_points.text = "Skillpoints left: "+str(GlobalVariables.skillpoints)

func setUnlock(skill: String, level: int):
	if skill in Skills.keys():
		print(skill)
		Skills[skill]["unlock"] = true
		Skills[skill]["level"] = level
		if Skills[skill]["ability"]:
			GlobalVariables.unlockedSkills.append(Skills.keys()[Skills.keys().find(skill)])
			print(GlobalVariables.unlockedSkills)
			GlobalVariables.unlockedSkillsTextures.append(Skills[skill]["texture"])
			print(GlobalVariables.unlockedSkillsTextures)

func setLock(skill: String):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = false
		if Skills[skill]["ability"]:
			if GlobalVariables.unlockedSkills.pop_at(GlobalVariables.unlockedSkills.find(Skills.keys()[Skills.keys().find(skill)])):
				GlobalVariables.unlockedSkills.remove_at(GlobalVariables.unlockedSkills.find(Skills.keys()[Skills.keys().find(skill)]))
				print("Removed item from ", GlobalVariables.unlockedSkills)
			if GlobalVariables.unlockedSkillsTextures.pop_at(GlobalVariables.unlockedSkills.find(Skills[skill]["texture"])):
				GlobalVariables.unlockedSkillsTextures.remove_at(GlobalVariables.unlockedSkills.find(Skills[skill]["texture"]))
				print(GlobalVariables.unlockedSkillsTextures)

func checkSkill(skill: String) -> bool:
	return Skills[skill]["unlock"]
