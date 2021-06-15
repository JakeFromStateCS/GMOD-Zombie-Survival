local JOB = {};
JOB.Name = "Boxer";
JOB.Color = Color( 50, 255, 100 );
JOB.Stats = {
	health = 100,
	armor = 0,
	runSpeed = 200,
	walkSpeed = 125,
};
JOB.DamageMultipliers = {
	["SMG1"] = 0.35,
	["Pistol"] = 0.5,
	["357"] = 0.60,
	["Melee"] = 3.2
};
JOB.Weapons = {
	["weapon_physcannon"] = 0,
	["BL_Fists"] = 0
};
JOB.Models = {
	"models/player/gman_high.mdl"
};
JOB.SkillReqs = {
	["Melee Weapons"] = 1
};

Base.Jobs:RegisterJob( JOB );