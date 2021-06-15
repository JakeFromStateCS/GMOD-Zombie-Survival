local RESOURCE = {};

RESOURCE.Name = "Wood";
RESOURCE.Color = Color( 100, 80, 50 );
RESOURCE.Weight = 10;
RESOURCE.Source = "source_tree";
RESOURCE.Sources = {
	["rp_downtown_v4c_v2"] = {
		{
			pos = Vector( -1257, -4655, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1257, -4755, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1257, -4855, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1257, -4955, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1257, -5055, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1257, -5155, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1057, -4655, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1057, -4755, -198 );
			ang = Angle( 0, 0, 0 );
		},
		{
			pos = Vector( -1057, -4855, -198 );
			ang = Angle( 0, 0, 0 );
		},
		
		
	},
	["rp_downtown_v4c_mg"] = {
		{
			pos = Vector( -3535, 1173, 0 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			pos = Vector( -3367, 1233, 0 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			pos = Vector( -3222, 1270, 0 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			pos = Vector( -3191, 1503, 0 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			pos = Vector( -3241, 1378, 0 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			pos = Vector( -3301, 1093, 0 ),
			ang = Angle( 0, 180, 0 )
		},
		
	}

}
RESOURCE.RespawnTime = 120;

Base.Resource:RegisterResource( RESOURCE );

/*
	Vector( 	-3535.826171875	,	1173.9390869141	,	0	)
Vector( 	-3367.1118164063	,	1233.3968505859	,	0	)
Vector( 	-3222.8491210938	,	1270.8542480469	,	0	)
Vector( 	-3191.400390625	,	1503.6669921875	,	0	)
Vector( 	-3241.5649414063	,	1378.8829345703	,	0	)
Vector( 	-3301.3283691406	,	1093.5764160156	,	0.60746002197266	)

*/