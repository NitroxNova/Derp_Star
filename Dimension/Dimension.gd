extends Node2D


func spawn_explosion(node):
	$Explosions.add_child(node)

func spawn_item(i):
	$Pick_Ups.add_child(i)

func spawn_boss_core(pos):
	var boss_core = load("res://Pick_Ups/Boss_Core/Boss_Core.tscn").instance()
	boss_core.position = pos
	spawn_item(boss_core)

func spawn_projectile(p):
	$Projectiles.add_child(p)
	
func spawn_bumper(b):
	b.connect("spawn_bumper",self,"spawn_bumper")
	b.connect("spawn_explosion",self,"spawn_explosion")
	b.connect("spawn_item",self,"spawn_item")
	b.connect("spawn_projectile",self,"spawn_projectile")
	$Bumper_List.add_child(b)

func spawn_boss(boss):
	boss.connect("spawn_boss",self,"spawn_boss")
	boss.connect("spawn_boss_core",self,"spawn_boss_core")
	boss.connect("spawn_item",self,"spawn_item")
	boss.connect("spawn_explosion",self,"spawn_explosion")
	boss.connect("boss_defeated",$Boss,"boss_defeated")
	$Boss.add_child(boss)
