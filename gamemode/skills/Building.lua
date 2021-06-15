local SKILL = {};
SKILL.Hooks = {};
SKILL.Name = "Building";
SKILL.Mult = 0.075;
SKILL.ExpRate = 0.05;

function SKILL.Hooks:PlayerSpawnedProp( client, model, ent )
	return true;
end;

Base.Skill:RegisterSkill( SKILL );