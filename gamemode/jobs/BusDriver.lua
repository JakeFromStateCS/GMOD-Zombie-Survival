local JOB = {};
JOB.Name = "Bus Driver";
JOB.Color = Color( 50, 255, 100 );
JOB.Stats = {
	health = 100,
	armor = 0,
	runSpeed = 200,
	walkSpeed = 125,
};
JOB.DamageMultipliers = {
	["SMG1"] = 0.0,
	["Pistol"] = 0.5,
	["357"] = 0.0
};
JOB.Weapons = {
	["weapon_physcannon"] = 0,
	["weapon_fists"] = 0
};
JOB.Models = {
	"models/player/kleiner.mdl"
};

Base.Jobs:RegisterJob( JOB );