extends TextureButton
class_name SkillNode

@onready var SkillLevel: Label = $SkillLevel
@onready var SkillBranch: Line2D = $SkillBranch
@export var MaxLevel:int = 3
@onready var skill_tree: Control = $"../.."
@onready var skillinfo: Label = $skillinfo

@export var SkillName: String
@export var shareParent: bool
@export var sharedParent: SkillNode
@export var sharedChild: SkillNode
@onready var SkillBranch2: Line2D = $SkillBranch2


var unlocked



var level: int = 0:
	set(value):
		level = value
		SkillLevel.text = str(level) + "/" + str(MaxLevel)

func _ready() -> void:
	skillinfo.visible=false
	unlocked = false
	process_mode = PROCESS_MODE_INHERIT
	self.self_modulate = Color(0.5, 0.5, 0.5)
	SkillLevel.text = str(level) + "/" + str(MaxLevel)
	if get_parent() is SkillNode:
		SkillBranch.add_point(self.global_position+size)
		SkillBranch.add_point(get_parent().global_position+size)

	if shareParent:
		SkillBranch2.add_point(self.global_position+size)
		SkillBranch2.add_point(sharedParent.global_position+size)


	

@onready var SkillTree = get_tree().get_first_node_in_group("SkillTree")

func lock():
	SkillTree.setLock(SkillName)
	self.self_modulate = Color(0.5, 0.5, 0.5)
	level = min(level-1, MaxLevel)
	SkillBranch.default_color = Color(0.5, 0.5, 0.5)
	SkillBranch2.default_color = Color(0.5, 0.5, 0.5)
	unlocked = false
	print(SkillName, " locked.")
	GlobalVariables.skillpoints += 1

func _on_pressed() -> void:
	if !unlocked and GlobalVariables.skillpoints > 0:
		if get_parent() is SkillNode:
			if get_parent().level == get_parent().MaxLevel:
				self.self_modulate = Color(1, 1, 1)
				level = min(level+1, MaxLevel)
				SkillBranch.default_color = Color(0.761, 0.745, 0.247)
				SkillTree.setUnlock(SkillName, level)
				unlocked = true
				print(SkillName + " unlocked.")
				GlobalVariables.skillpoints -= 1
				
		
		if sharedParent is SkillNode and shareParent:
			if sharedParent.level == sharedParent.MaxLevel:
				self.self_modulate = Color(1, 1, 1)
				level = min(level+1, MaxLevel)
				SkillBranch2.default_color = Color(0.761, 0.745, 0.247)
				SkillTree.setUnlock(SkillName, level)
				unlocked = true
				print(SkillName + " unlocked.")
				GlobalVariables.skillpoints -= 1
				
		if self is SkillNode and get_parent() is not SkillNode:
			level = min(level+1, MaxLevel)
			self.self_modulate = Color(1, 1, 1)
			SkillTree.setUnlock(SkillName, level)
			unlocked = true
			print(SkillName + " unlocked.")
			GlobalVariables.skillpoints -= 1
		
	elif self is SkillNode and unlocked == true:
		var childButtons = []
		var child_is_unlocked
		for child in self.get_children():
			if child is SkillNode:
				childButtons.append(child)
		if sharedChild != null:
			childButtons.append(sharedChild)
		print(childButtons)
		#var another_child_is_unlocked = true
		#for child in childButtons:
			#if !child.unlocked:
				#child_is_unlocked = false
			#if !child_is_unlocked:
				#break
				#
		#for child in childButtons:
			#if !child.unlocked:
				#another_child_is_unlocked = false
			#else:
				#another_child_is_unlocked=true
			#
		
		if !childButtons.is_empty()	:
			if childButtons.size() == 2:
				if !(childButtons[0].unlocked or childButtons[1].unlocked):
					lock()
				else:
					print("persehiki")
			elif childButtons.size() == 1:
				if !childButtons[0].unlocked:
					lock()
				else:
					print("persehiki")
		elif childButtons.is_empty():
			lock()
	
	
	var skills = get_children()

	
	skills.append(sharedChild)
	
	for skill in skills:
		if skill is SkillNode and level == MaxLevel:
			skill.disabled = false
	print(self.unlocked)
	check_all_skills(SkillName)
	
func check_all_skills(SkillName : String) -> void:
		match SkillName:
			"Dash":
				pass
			"+10% Attack damage":
				if SkillTree.Skills[SkillName]["unlock"]:
					print("dmg buffed")
					GlobalVariables.basicAttackDamage = GlobalVariables.basicAttackDamage * 3
				else:
					GlobalVariables.basicAttackDamage = GlobalVariables.baseBasicAttackDamage * 0.9
					print("dmg lowered")
			"Holy Projectile":
				pass
			"+5% Movement Speed":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.playerSpeed = GlobalVariables.playerSpeed * 1.1
					print(GlobalVariables.playerSpeed)
					print("speed buffed")
				else:
					GlobalVariables.playerSpeed = GlobalVariables.playerSpeed * 0.95
					print("speed lowered")
			"+5% Health":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.playerHealth = GlobalVariables.playerHealth * 1.05
					print("hp buffed")
				else:
					GlobalVariables.playerHealth = GlobalVariables.playerHealth * 0.95
					print("hp lowered")
			"+5% Attack Damage":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.basicAttackDamage = GlobalVariables.basicAttackDamage * 1.1
					print("dmg added again")
				else:
					GlobalVariables.basicAttackDamage = GlobalVariables.baseBasicAttackDamage * 0.9
					print("dmg lowered again")
			"5% Cooldown Reduction":
				if SkillTree.Skills[SkillName]["unlock"]:
					print("Spell cooldowns reduced")
					GlobalVariables.spellTimer = GlobalVariables.spellTimer * 0.95
				else:
					print("Spell cooldowns normal")
					GlobalVariables.spellTimer = GlobalVariables.spellTimer * 1.05
			"Jump":
				pass
			"10% Non-Spell Cooldown Reduction":
				if SkillTree.Skills[SkillName]["unlock"]:
					print("Non-Spell Cooldowns reduced")
					GlobalVariables.dashTimer = GlobalVariables.dashTimer * 0.95
				else:
					print("Non-Spell Cooldowns normal")
					GlobalVariables.dashTimer = GlobalVariables.dashTimer * 1.05
			"Taunt":
				pass
			"+10% Armor":
				if SkillTree.Skills[SkillName]["unlock"]:
					print("Armor Increased")
					GlobalVariables.playerArmor = GlobalVariables.playerArmor * 1.1
				else:
					print("Armor Decreased")
					GlobalVariables.playerArmor = GlobalVariables.playerArmor * 0.9
			"Holy Shield":
				pass
			"+5% Attack Damage 2":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.basicAttackDamage = GlobalVariables.basicAttackDamage * 1.05
					print("Dmg added once again")
				else:
					GlobalVariables.basicAttackDamage = GlobalVariables.baseBasicAttackDamage * 0.95
					print("Dmg lowered once again")
			"+10% Health":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.playerHealth = GlobalVariables.playerHealth * 1.1
					print("Health Increased")
				else:
					GlobalVariables.playerHealth = GlobalVariables.playerHealth * 0.9
					print("Health Decreased")
			"+5% Attack Damage 3":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.basicAttackDamage = GlobalVariables.basicAttackDamage * 1.05
					print("Damage added OOOONCE again!")
				else:
					GlobalVariables.basicAttackDamage = GlobalVariables.baseBasicAttackDamage * 0.95
					print("Damage reduced again again again.")
			"+5% Spell Damage":
				if SkillTree.Skills[SkillName]["unlock"]:
					GlobalVariables.spellDamage = GlobalVariables.spellDamage * 1.05
					print("Spell damage increased.")
				else:
					GlobalVariables.spellDamage = GlobalVariables.spellDamage * 0.95
					print("Spell damage reduced.")
			"Extra Dash":
				pass
			"Taunt Buff":
				pass
			"Holy Shield Buff":
				pass
			"Leap":
				pass
			"Spin":
				pass
			"AoE":
				pass
func _on_mouse_entered() -> void:
	skillinfo.visible = true
	skillinfo.text = SkillName

func _on_mouse_exited() -> void:
	skillinfo.visible = false
