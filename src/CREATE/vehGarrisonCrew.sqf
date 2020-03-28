params ["_marcador","_grupo","_veh"];
private _posVeh = [];
private _dist = 150;
if (_veh isKindOf "AIR") then
	{
	_posVeh = getMarkerPos _marcador;
	_dist = 300;
	}
else
	{
	_posVeh = getPos _veh
	};
private _unidades = units _grupo;
_casas = (nearestObjects [_posVeh, ["house"], _dist]) select {!((typeOf _x) in UPSMON_Bld_remove)};

if (count _casas > 0) then
	{
	{
	_casa = selectRandom _casas;
	_x setPosATL (selectRandom ([_casa] call BIS_fnc_buildingPositions));
	} forEach _unidades;
	};
{_x forceSpeed 0} forEach _unidades;
private _lider = leader _grupo;
private _eny = objNull;
_salir = false;
while {!_salir} do
	{
	if (spawner getVariable _marcador == 2) exitWith {_salir = true};
	_eny = (_lider findNearestEnemy _lider);
	if !(isNull _eny) exitWith {};
	if ([_marcador] call BIS_fnc_taskExists) exitWith {};
	};
if (_salir) exitWith
	{
	{
	if (alive _x) then
		{
		deleteVehicle _x
		};
	} forEach _unidades;
	deleteGroup _grupo;
	};
{_x forceSpeed -1} forEach _unidades;
_grupo addVehicle _veh;
_unidades orderGetin true;
_wp0 = _grupo addWaypoint [_posVeh, 0];
_wp0 setWaypointType "GETIN";
_wp0 setWaypointBehaviour "AWARE";
_wp0 setWaypointSpeed "FULL";
private _pos = if (!isNull _eny) then {position _eny} else {getMarkerPos _marcador};
_wp1 = _grupo addWaypoint [_pos,1];
_wp1 setWaypointType "SAD";
_wp1 setWaypointBehaviour "COMBAT";
waitUntil {sleep 1;(spawner getVariable _marcador == 2)};
{
[_x] spawn
	{
	private ["_veh"];
	_veh = _this select 0;
	waitUntil {sleep 1; !([distanciaSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
	deleteVehicle _veh;
	};
} forEach _unidades;