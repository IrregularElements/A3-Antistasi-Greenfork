if (!isServer and hasInterface) exitWith{};
private _marcador = _this select 0;
private _tsk = "";
private _posicion = getMarkerPos _marcador;
private _grupos = [];
private _nombredest = [_marcador] call A3A_fnc_localizar;
private _lado = lados getVariable [_marcador,sideUnknown];

private _size = [_marcador] call A3A_fnc_sizeMarker;
private _ang = (getMarkerPos respawnBuenos) getDir _posicion;
_ang = _ang + ((random 180) - 90);
private _posTsk = _posicion getPos [distanciaSPWN,_ang];
while {surfaceIsWater _posTsk} do
	{
	_ang = _ang + 10;
	private _posTsk = _posicion getPos [distanciaSPWN,_ang];
	};
private _road = [_posTsk] call A3A_fnc_findNearestGoodRoad;
_posTsk = position _road;
private _pool = if (_lado == malos) then {vehNATOAPC + [vehNATOTank,vehNATOAA,vehNATOMRLS]} else {vehCSATAPC + [vehCSATTank,vehCSATAA,vehCSATMRLS]};
_pool = _pool select {[_x] call A3A_fnc_vehAvailable};
private _tipoVeh = selectRandom _pool;
private _vehObj = _tipoVeh createVehicle _posTsk;
_vehObj setDir (getDir _road);
_vehObj setHit [(getText( configFile >> "CfgVehicles" >> _tipoVeh >> "HitPoints" >> "HitEngine" >> "name" )),1];
_vehObj setHit [(getText( configFile >> "CfgVehicles" >> _tipoVeh >> "HitPoints" >> "HitFuel" >> "name" )),1];
_vehObj setHit [(getText( configFile >> "CfgVehicles" >> _tipoVeh >> "HitPoints" >> "HitLTrack" >> "name" )),1];
_vehObj setHit [(getText( configFile >> "CfgVehicles" >> _tipoVeh >> "HitPoints" >> "HitRTrack" >> "name" )),1];
_vehObj allowCrewInImmobile true;
private _dificil = (random 10 < tierWar);
private _texto = format ["We know a %2 is stuck in the surroundings of %1. Go there and capture or destroy it before an engineer team reaches it's position and repairs it",_nombredest,getText (configFile >> "CfgVehicles" >> _tipoVeh >> "displayName")];
private _texto1 = format ["We know a %2 is stuck in the surroundings of %1. Go there and protect our engineer team until they move it back to base",_nombredest,getText (configFile >> "CfgVehicles" >> _tipoVeh >> "displayName")];
[[buenos,civilian],"DES",[_texto,"Capture or Destroy Vehicle",_nombredest],_posTsk,false,0,true,"Destroy",true] call BIS_fnc_taskCreate;
[[_lado],"DES1",[_texto1,"Protect Stuck Vehicle",_nombredest],_posTsk,false,0,true,"Defend",true] call BIS_fnc_taskCreate;
misiones pushBack ["RES","CREATED"]; publicVariable "misiones";
_max = if (_dificil) then {2} else {1};
for "_i" from 1 to _max do
	{
	_tipoGrupo = if (_lado == malos) then {selectRandom (gruposNATOSquad-[NATOSquadEng])} else {selectRandom (gruposCSATquad-[CSATSquadEng])};
	_grupo = [(_posTsk getPos [20,random 360]),_lado,_tipoGrupo,false] call A3A_fnc_spawnGroup;
	_grupos pushBack _grupo;
	{[_x] call A3A_fnc_NATOInit} forEach units _grupo;
	[_grupo,true] spawn A3A_fnc_digIn;
	};
sleep 300;
_tipoGrupo = if (_lado == malos) then {NATOSquadEng} else {CSATSquadEng};
_grupo = [_posicion,_lado,_tipoGrupo,false] call A3A_fnc_spawnGroup;
_grupos pushBack _grupo;
{[_x] call A3A_fnc_NATOInit} forEach units _grupo;
_grupo addVehicle _vehObj;
(units _grupo) orderGetIn true;
private _wp = _grupo addWaypoint [_posTsk,0];
_wp setWaypointType "MOVE";


waitUntil {sleep 1;((side (driver _vehObj) == buenos) and (canMove _vehObj)) or !(alive _vehObj) or (side (driver _vehObj) == _lado)};

if (((side (driver _vehObj) == buenos) and (canMove _vehObj)) or !(alive _vehObj)) then
	{
	["DES",[_texto,"Capture or Destroy Vehicle",_nombredest],_posTsk,"SUCCEEDED","Destroy"] call A3A_fnc_taskUpdate;
	["DES1",[_texto1,"Protect Stuck Vehicle",_nombredest],_posTsk,"FAILED","Defend"] call A3A_fnc_taskUpdate;
	{if (_x distance _vehObj < 500) then {[10*_max,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5*_max,theBoss] call A3A_fnc_playerScoreAdd;
	}
else
	{
	sleep 30;
	_grupo = createGroup _lado;
	_grupos pushBack _grupo;
	(crew _vehObj) join _grupo;
	_wp = _grupo addWayPoint [_posicion,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	waitUntil {sleep 1;((side (driver _vehObj) == buenos) and (canMove _vehObj)) or !(alive _vehObj) or (_vehObj distance _posicion < (_size*2))};
	if (_vehObj distance _posicion < (_size*2)) then
		{
		["DES",[_texto,"Capture or Destroy Vehicle",_nombredest],_posTsk,"FAILED","Destroy"] call A3A_fnc_taskUpdate;
		["DES1",[_texto1,"Protect Stuck Vehicle",_nombredest],_posTsk,"SUCCEEDED","Defend"] call A3A_fnc_taskUpdate;
		}
	else
		{
		["DES",[_texto,"Capture or Destroy Vehicle",_nombredest],_posTsk,"SUCCEEDED","Destroy"] call A3A_fnc_taskUpdate;
		["DES1",[_texto1,"Protect Stuck Vehicle",_nombredest],_posTsk,"FAILED","Defend"] call A3A_fnc_taskUpdate;
		{if (_x distance _vehObj < 500) then {[10*_max,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5*_max,theBoss] call A3A_fnc_playerScoreAdd;
		};
	};
if !([distanciaSPWN,1,_vehObj,buenos] call A3A_fnc_distanceUnits) then {deleteVehicle _vehObj} else {[_vehObj] call A3A_fnc_AIvehInit};
{
_grupo = _x;
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,buenos] call A3A_fnc_distanceUnits)};
deleteVehicle _x;
} forEach units _grupo;
deleteGroup _grupo;
} forEach _grupos;