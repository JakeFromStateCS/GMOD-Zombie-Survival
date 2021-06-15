local JOB = {};
JOB.Name = "Builder";
JOB.Color = Color( 50, 255, 100 );
JOB.Default = false;
JOB.Stats = {
	health = 100,
	armor = 0,
	runSpeed = 200,
	walkSpeed = 140,
};
JOB.DamageMultipliers = {
	["SMG1"] = 0.35,
	["Pistol"] = 0.5,
	["357"] = 0.60
};
JOB.Weapons = {
	["gmod_tool"] = 0,
	["weapon_physgun"] = 0
};
JOB.Models = {
	"models/player/kleiner.mdl"
};
JOB.SkillReqs = {
	["Building"] = 1
};

Base.Jobs:RegisterJob( JOB );