extends Dimension

var tutorial_objective = MultiObjective.new()
enum stages {MOVEMENT_KEYS,DOOR_1,BOSS_WYRM}
var current_stage = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Boss/Spawn_Timer.stop()
	
	#spawn obsticles
	var barrier = Entity_Spawner.blockade()
	barrier.c_add(Position_Component.new(480,30))
	
	#objectives
	var move_keys = MultiObjective.new("Press the Q, W, E, R, T keys to control the Derp Star's movement.")
	move_keys.add_objective(SimpleObjective.new("press the q key"))
	move_keys.add_objective(SimpleObjective.new("press the w key"))
	move_keys.add_objective(SimpleObjective.new("press the e key"))
	move_keys.add_objective(SimpleObjective.new("press the r key"))
	move_keys.add_objective(SimpleObjective.new("press the t key"))
	tutorial_objective.add_objective(move_keys)
	move_keys.objective_complete.connect(next_stage)
	var door1 = SimpleObjective.new("Break Down the Door!")
	tutorial_objective.add_objective(door1)
	door1.objective_complete.connect(next_stage)
	
	tutorial_objective.add_objective(SimpleObjective.new("Kill the Space Wyrm!"))
	next_stage()
	
func next_stage():
	if current_stage == stages.BOSS_WYRM:
		$Boss/Spawn_Timer.stop()
	current_stage += 1
	$Tutorial_Prompt.text = tutorial_objective.objectives[current_stage].description
	if current_stage == stages.BOSS_WYRM:
		$Boss.spawn()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event:InputEvent):
	if current_stage == stages.MOVEMENT_KEYS and event is InputEventKey:
		for i in 5:
			if event.is_action_pressed("thruster_" + str(i+1)):
				tutorial_objective.objectives[0].objectives[i].set_complete()	
