if (!isServer and hasInterface) exitWith{};
private _marcador = _this select 0;
private _tsk = "";
private _posicion = getMarkerPos _marcador;
private _POWs = [];
private _grupos = [];
private _attackers = [];
private _nombredest = [_marcador] call A3A_fnc_localizar;
private _lado = lados getVariable [_marcador,sideUnknown];
private _texto = format ["A group of brave soldiers have been ambushed and pinned in %1. Go there and defeat their ambushers before is too late",_nombredest];
private _size = [_marcador] call A3A_fnc_sizeMarker;

private _posTsk = _posicion getPos [random (_size/2),random 360];
while {surfaceIsWater _posTsk} do
	{
	_posTsk = _posicion getPos [random (_size/2),random 360];
	};
[[buenos,civilian],"RES",[_texto,"Squad Rescue",_nombredest],_posTsk,false,0,true,"run",true] call BIS_fnc_taskCreate;
[[_lado],"RES1",[_texto,"Eliminate Squad",_nombredest],_posTsk,false,0,true,"Attack",true] call BIS_fnc_taskCreate;
misiones pushBack ["RES","CREATED"]; publicVariable "misiones";

waitUntil {sleep 1; spawner getVariable [_marcador,0] != 2};

private _tipoGrupo = [];
{
_index = if (random 20 <= skillFIA) then {1} else {0};
_tipoGrupo pushBack (_x select _index);
} forEach gruposSDKSquad;
_grupo = [_posTsk, buenos, _tipoGrupo,true] call A3A_fnc_spawnGroup;
_grupos pushBack _grupo;
{[_x] call A3A_fnc_FIAinitBASES; _POWs pushBack _x} forEach units _grupo;
[_grupo,true] spawn A3A_fnc_digIn;
private _dificil = (random 15 < tierWar);
private _max = if (_dificil) then {3} else {1};
for "_i" from 0 to _max do
	{
	_ang = _i * 90;
	_pos = _posicion getPos [_size,_ang];
	while {(surfaceIsWater _pos)} do
		{
		_ang = _ang + 5;
		_pos = _posicion getPos [_size,_ang];
		};
	_tipoGrupo = if (_lado == malos) then {selectRandom gruposNATOSquad} else {selectRandom gruposCSATquad};
	_grupo = [_pos,_lado,_tipoGrupo,false] call A3A_fnc_spawnGroup;
	_grupos pushBack _grupo;
	{[_x] call A3A_fnc_NATOInit; _attackers pushBack _x} forEach units _grupo;
	_wp = _grupo addWaypoint [_posTsk, 0];
	_wp setWaypointType "SAD";
	_grupo spawn A3A_fnc_attackDrillAI;
	};
private _solMin = round ((count _attackers)*0.25);

waitUntil {sleep 1;({alive _x} count _POWs == 0) or ({[_x] call A3A_fnc_canFight} count _attackers < _solMin)};

if ({alive _x} count _POWs == 0) then
	{
	["RES",[_texto,"Squad Rescue",_nombredest],_posTsk,"FAILED","run"] call A3A_fnc_taskUpdate;
	}
else
	{
	_grupo = (_grupos select {side _x == buenos}) select 0;
	_grupo setVariable ["attackDrill",true];
	sleep 45;
	_wp = _grupo addWaypoint [getMarkerPos respawnBuenos,0];
	_wp setWaypointType "MOVE";
	_grupo spawn A3A_fnc_attackDrillAI;
	waitUntil {sleep 1;({alive _x} count _POWs == 0) or ({_x distance (getMarkerPos respawnBuenos) < 300} count _POWs > 0) or ({[_x] call A3A_fnc_canFight} count _attackers < 4)};
	if ({alive _x} count _POWs == 0) then
		{
		["RES",[_texto,"Squad Rescue",_nombredest],_posTsk,"FAILED","run"] call A3A_fnc_taskUpdate;
		}
	else
		{
		["RES",[_texto,"Squad Rescue",_nombredest],_posTsk,"SUCCEEDED","run"] call A3A_fnc_taskUpdate;
		_cuenta = 0;
		_hr = 0;
		{
		_hr = _hr + 1;
		_cuenta = _cuenta + (server getVariable [typeOf _x,0]);
		} forEach (_POWs select {alive _x});
		[_hr,_cuenta] remoteExec ["A3A_fnc_resourcesFIA",2];
		{if ((_x distance getMarkerPos respawnBuenos < 500) or (_x distance _posicion < 500)) then {[(_hr*_max),_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[(_hr*_max),theBoss] call A3A_fnc_playerScoreAdd;
		};
	};
[1200,"RES"] spawn A3A_fnc_borrarTask;
[10,"RES1"] spawn A3A_fnc_borrarTask;

{
_grupo = _x;
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,buenos] call A3A_fnc_distanceUnits)};
deleteVehicle _x;
} forEach units _grupo;
deleteGroup _grupo;
} forEach _grupos;