private ["_grupo","_killer","_marcador","_super","_enemy","_lado"];
_grupo = _this select 0;
_killer = _this select 1;
_lado = side _grupo;
{
if (fleeing _x) then
	{
	if ([_x] call A3A_fnc_canFight) then
		{
		_enemy = _x findNearestEnemy _x;
		if (!isNull _enemy) then
			{
			if ((_x distance _enemy < 50) and (vehicle _x == _x)) then
				{
				[_x] spawn A3A_fnc_surrenderAction;
				}
			else
				{
				if (_x == leader group _x) then
					{
					_super = false;
					_marcador = (leader _grupo) getVariable "marcador";
					if (!isNil "_marcador") then
						{
						if (_marcador in aeropuertos) then {_super = true};
						};
					if ([_x] call A3A_fnc_hasRadio) then
						{
						if (vehicle _killer == _killer) then
							{
							[[getPosASL _enemy,_lado,"Normal",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]
							}
						else
							{
							if (vehicle _killer isKindOf "Air") then {[[getPosASL _enemy,_lado,"Air",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]} else {if (vehicle _killer isKindOf "Tank") then {[[getPosASL _enemy,_lado,"Tank",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]} else {[[getPosASL _enemy,_lado,"Normal",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]}};
							};
						};
					};
				if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then {[_x,_enemy] call A3A_fnc_fuegoSupresor} else {[_x,_x,_enemy] spawn A3A_fnc_cubrirConHumo};
				};
			};
		};
	}
else
	{
	if ([_x] call A3A_fnc_canFight) then
		{
		_enemy = _x findNearestEnemy _x;
		if (!isNull _enemy) then
			{
			if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then
				{
				[_x,_enemy] call A3A_fnc_fuegoSupresor;
				}
			else
				{
				if (sunOrMoon == 1 or haveNV) then
					{
					[_x,_x,_enemy] spawn A3A_fnc_cubrirConHumo;
					};
				};
			};
		if (random 1 < 0.5) then {if (count units _grupo > 0) then {_x allowFleeing (1 -(_x skill "courage") + (({!([_x] call A3A_fnc_canFight)} count units _grupo)/(count units _grupo)))}};
		};
	};
sleep 1 + (random 1);
} forEach units _grupo;

