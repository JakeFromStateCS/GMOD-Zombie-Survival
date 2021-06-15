local JOB = {};
JOB.Name = "Gangster";
JOB.Color = Color( 50, 50, 50 );
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
	["swb_m3super90"] = 25,
	["weapon_physcannon"] = 0
};
JOB.Models = {
	"models/player/group03/male_01.mdl"
};

Base.Jobs:RegisterJob( JOB );