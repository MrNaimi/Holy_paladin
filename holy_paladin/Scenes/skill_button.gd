extends TextureButton
class_name SkillNode

@onready var SkillLevel: Label = $SkillLevel
@onready var SkillBranch: Line2D = $SkillBranch
@export var MaxLevel:int = 3
@onready var skill_tree: Control = $"../.."

@export var SkillName: String
@export var shareParent: bool
@export var sharedParent: SkillNode
@export var sharedChild: SkillNode
@onready var SkillBranch2: Line2D = $SkillBranch2



var level: int = 0:
	set(value):
		level = value
		SkillLevel.text = str(level) + "/" + str(MaxLevel)

func _ready() -> void:
	process_mode = PROCESS_MODE_INHERIT
	
	print(SkillTree)
	self.self_modulate = Color(0.5, 0.5, 0.5)
	SkillLevel.text = str(level) + "/" + str(MaxLevel)
	if get_parent() is SkillNode:
		SkillBranch.add_point(self.global_position+size/2)
		SkillBranch.add_point(get_parent().global_position+size/2)

	if shareParent:
		SkillBranch2.add_point(self.global_position+size/2)
		SkillBranch2.add_point(sharedParent.global_position+size/2)

@onready var SkillTree = get_tree().get_first_node_in_group("SkillTree")

func _on_pressed() -> void:
	
	SkillTree.setUnlock(SkillName, level)
	
	print(SkillTree.checkSkill("Dash"))
	
	if get_parent() is SkillNode:
		if get_parent().level == get_parent().MaxLevel:
			self.self_modulate = Color(1, 1, 1)
			level = min(level+1, MaxLevel)
			SkillBranch.default_color = Color(0.761, 0.745, 0.247)
	
	if sharedParent is SkillNode and shareParent:
		if sharedParent.level == sharedParent.MaxLevel:
			self.self_modulate = Color(1, 1, 1)
			level = min(level+1, MaxLevel)
			SkillBranch2.default_color = Color(0.761, 0.745, 0.247)
			
	if self is SkillNode and get_parent() is not SkillNode:
		level = min(level+1, MaxLevel)
		self.self_modulate = Color(1, 1, 1)
		
	var skills = get_children()
	
	skills.append(sharedChild)
	
	for skill in skills:
		if skill is SkillNode and level == MaxLevel:
			skill.disabled = false
