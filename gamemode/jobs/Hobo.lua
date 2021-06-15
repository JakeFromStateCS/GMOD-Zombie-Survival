local JOB = {};
JOB.Name = "Hobo";
JOB.Color = Color( 50, 255, 100 );
JOB.Default = false;
JOB.Stats = {
	health = 100,
	armor = 0,
	runSpeed = 280,
	walkSpeed = 120,
};
JOB.DamageMultipliers = {
	["SMG1"] = 1.0,
	["Pistol"] = 0.5,
	["357"] = 0.60,
	["Melee"] = 1.2
};
JOB.Weapons = {
	["weapon_bugbait"] = 0,
	["weapon_fists"] = 0
};
JOB.Models = {
	"models/player/corpse1.mdl"
};

Base.Jobs:RegisterJob( JOB );