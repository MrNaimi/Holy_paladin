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
		"ability": false
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
			#GlobalVariables.unlockedSkillsTextures.append(Skills[skill]["texture"])
			#print(GlobalVariables.unlockedSkillsTextures)
			
			for button in get_parent().get_parent().get_child(0).get_child(1).actionbuttons:
				if !button.texture_changed:
					button.visible = true
					button.ability_name =  Skills.keys()[Skills.keys().find(skill)]
					button.changeTexture(Skills[skill]["texture"])
					button.texture_changed = true
					break
				else:
					continue
			
func setLock(skill: String):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = false
		if Skills[skill]["ability"]:
			if GlobalVariables.unlockedSkills.pop_at(GlobalVariables.unlockedSkills.find(Skills.keys()[Skills.keys().find(skill)])):
				GlobalVariables.unlockedSkills.remove_at(GlobalVariables.unlockedSkills.find(Skills.keys()[Skills.keys().find(skill)]))
				print("Removed item from ", GlobalVariables.unlockedSkills)
			#if GlobalVariables.unlockedSkillsTextures.pop_at(GlobalVariables.unlockedSkills.find(Skills[skill]["texture"])):
				#GlobalVariables.unlockedSkillsTextures.remove_at(GlobalVariables.unlockedSkills.find(Skills[skill]["texture"]))
				#print(GlobalVariables.unlockedSkillsTextures)
			
			for button in get_parent().get_parent().get_child(0).get_child(1).actionbuttons:
				if button.texture_changed and button.ability_name == Skills.keys()[Skills.keys().find(skill)]:
					#print(Skills[skill]["ability"])
					button.visible = false
					button.changeTexture(null)
					button.texture_changed = false
					break
				else:
					continue
			var buttonsafterempty = []
			var emptyspacefound = false
			for button in get_parent().get_parent().get_child(0).get_child(1).actionbuttons:
				if !button.visible:
					emptyspacefound = true
					
					#print(button.ability_name," not visible")
				else:
					if emptyspacefound:
						buttonsafterempty.append(button.ability_name)
						#print("empty space found in between")
						#break
					#print(button.ability_name," visible")
			#print()
			#print(buttonsafterempty)
			#print()
			#for button in buttonsafterempty:
				#print(button)
			#var testarray = GlobalVariables.unlockedSkills
			#for buttonname in testarray:
				#if buttonname in buttonsafterempty:
					#setLock(buttonname)
					#setUnlock(buttonname,1)
				#
			#
			#if emptyspacefound:
				#notvisiblebuttons[-1].changeTexture(Skills[skill]["texture"])
				#notvisiblebuttons[-1].texture_changed = true
				#notvisiblebuttons[-1].ability_name =  Skills.keys()[Skills.keys().find(skill)]
				#notvisiblebuttons[-1].visible = true
			
					
					
func checkSkill(skill: String) -> bool:
	return Skills[skill]["unlock"]
