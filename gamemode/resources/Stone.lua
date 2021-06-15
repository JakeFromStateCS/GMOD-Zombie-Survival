local RESOURCE = {};

RESOURCE.Name = "Stone";
RESOURCE.Color = Color( 100, 100, 100 );
RESOURCE.Weight = 30;
RESOURCE.Source = "source_rock";
RESOURCE.Sources = {
	["rp_downtown_v4c_v2"] = {
		{
			pos = Vector( 2843, -2350, -150 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( 2843, -2300, -150 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( 2843, -2250, -150 );
			ang = Angle( 0, 0, 0 );
		},
		
		
	}
}
RESOURCE.RespawnTime = 120;

Base.Resource:RegisterResource( RESOURCE );