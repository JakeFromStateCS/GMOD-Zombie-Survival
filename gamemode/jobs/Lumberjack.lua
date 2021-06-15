local JOB = {};
JOB.Name = "Lumberjack";
JOB.Color = Color( 200, 100, 50 );
JOB.Stats = {
	health = 100,
	armor = 0,
	runSpeed = 200,
	walkSpeed = 125,
};
JOB.DamageMultipliers = {
	["SMG1"] = 0.35,
	["Pistol"] = 0.5,
	["357"] = 0.60
};
JOB.Weapons = {
	["weapon_physcannon"] = 0,
	["weapon_fists"] = 0,
	["weapon_crowbar"] = 0
};
JOB.Models = {
	"models/player/kleiner.mdl"
};
JOB.SkillReqs = {
	["Woodcutting"] = 1
};
JOB.SkillMult = {
	["Woodcutting"] = 0.2
};

Base.Jobs:RegisterJob( JOB );