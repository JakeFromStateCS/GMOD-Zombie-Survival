local JOB = {};
JOB.Name = "Police";
JOB.Color = Color( 50, 100, 255 );
JOB.Default = false;
JOB.Stats = {
	health = 100,
	armor = 100,
	runSpeed = 250,
	walkSpeed = 100,
};
JOB.DamageMultipliers = {
	["SMG1"] = 1.0,
	["Pistol"] = 0.5,
	["357"] = 0.60
};
JOB.Weapons = {
	["Weapon_SMG1"] = 120,
	["swb_m4a1"] = 100,
	["weapon_357"] = 50,
	["weapon_stunstick"] = 0,
	["weapon_physcannon"] = 0,
	["swb_awp"] = 90
};
JOB.Models = {
	"models/player/police.mdl"
};
JOB.SkillReqs = {
	["Arresting"] = 1
};
JOB.SkillMult = {
	["Arresting"] = 0.2
};

Base.Jobs:RegisterJob( JOB );