/*
	Unnamed Project
    --By Blasphemy
*/
--
Base = Base or {};
Base.Modules = Base.Modules or {};
Base.Config = Base.Config or {};

Base.Config.Debug = true; -- matt, if you continue to leave your code in debug mode every time you push an update i am going to tear out your beating heart and feed it to your mother
Base.Config.WalkSpeed = 170;
Base.Config.RunSpeed = 500;
Base.Config.CanSuicide = true;
Base.Config.CanFlashlight = true;
--Base.Config.PlayerModel = "models/XQM/Rails/gumball_1.mdl";
Base.Config.ConsoleColor = Color( 255, 255, 255 );
Base.Config.Colors = {
	["SH"] = Color( 255, 200, 100 ),
	["SV"] = Color( 100, 100, 255 ),
	["CL"] = Color( 255, 100, 100 )
}
Base.Config.LoadColor = Color( 255, 100, 0 );
Base.Config.ModColor = Color( 100, 255, 0 );
Base.Config.HookColor = Color( 255, 100, 0 );
Base.Config.NetColor = Color( 255, 255, 100 );
Base.Config.LibColor = Color( 255, 200, 0 );
Base.Config.SkillColor = Color( 100, 100, 255 );

Base.Config.AttackAnim = ACT_MELEE_ATTACK_SWING;
Base.Config.LobbyRespawn = true;