local JOB = {};
JOB.Name = "Citizen";
JOB.Color = Color( 50, 255, 100 );
JOB.Default = true;
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
	["weapon_fists"] = 0
};
JOB.Models = {
	"models/player/kleiner.mdl"
};

Base.Jobs:RegisterJob( JOB );