if (!isServer and hasInterface) exitWith{};

private _marcador = _this select 0;
private _posicion = getMarkerPos _marcador;
private _ciudad = [ciudades,_posicion] call BIS_fnc_nearestPosition;
private _nombredest = [_ciudad] call A3A_fnc_localizar;
private _lado = lados getVariable [_ciudad,sideUnknown];
private _dificil = (random 10) <= tierWar;
private _tiempoLim = if (_dificil) then {4} else {8};
_fechalim = [date select 0, date select 1, date select 2, (date select 3) + _tiempoLim, date select 4];
_fechalimnum = dateToNumber _fechalim;
private _texto = format ["We expect to receive a supply box from international aid in this position near %1. Go there before %2:%3, wait for the supply boat, load the cargo in some vehicle and bring the stuff back to base",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4];
[[buenos,civilian],"LOG",[_texto,"Sea Supply",_nombredest],_posicion,false,0,true,"rearm",true] call BIS_fnc_taskCreate;
misiones pushBack ["LOG","CREATED"]; publicVariable "misiones";


waitUntil {sleep 2; (dateToNumber date > _fechalimnum) or ([80,1,_posicion,buenos] call A3A_fnc_distanceUnits)};

if (dateToNumber date > _fechalimnum) exitWith
	{
	["LOG",[_texto,"Sea Supply",_nombredest],_posicion,"FAILED","rearm"] call A3A_fnc_taskUpdate;
	[1200,"LOG"] spawn A3A_fnc_borrarTask;
	};
{if (isPlayer _x) then {[petros,"Hint","Wait here for the boat"] remoteExec ["A3A_fnc_commsMP",_x]}} forEach ([80,0,_posicion,buenos] call A3A_fnc_distanceUnits);
private _posSpawn = getMarkerPos ([seaAttackSpawn,_posicion] call BIS_fnc_nearestPosition);
private _vehObj = vehSDKBoat createVehicle _posSpawn;
private _grupo = createGroup buenos;
private _driver = _grupo createUnit [SDKUnarmed, _posSpawn, [], 0, "NONE"];
[_driver] spawn A3A_fnc_FIAInit;
[_vehObj] call A3A_fnc_AIvehInit;
_driver moveInDriver _vehObj;
_grupo addWaypoint [_posicion,0];
_grupo addWaypoint [_posSpawn,1];
_sentQRF = false;
while {true} do
	{
	sleep 5;
	if (!(alive _vehObj) or (_vehObj distance2D _posicion < 25) or (dateToNumber date > _fechalimnum)) exitWith {};
	if !(_sentQRF) then
		{
		_sentQRF = true;
		if (_lado knowsAbout _vehObj > 1.4) then {[[_posicion,_lado,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
		}
	};
if !(_vehObj distance2D _posicion < 25) exitWith
	{
	["LOG",[_texto,"Sea Supply",_nombredest],_posicion,"FAILED","rearm"] call A3A_fnc_taskUpdate;
	[1200,"LOG"] spawn A3A_fnc_borrarTask;
	};
private _posCaja = getPos _vehObj;
private _ang = _posSpawn getDir _vehObj;
private _dist = 3;
while {surfaceIsWater _posCaja} do
	{
	_posCaja = _posCaja getPos [_dist,_ang];
	_dist = _dist + 1;
	};
_caja = objNull;
if (_lado == malos) then
	{
	_caja = NATOAmmoBox createVehicle _posCaja;
	_nul = [_caja] call A3A_fnc_NATOcrate;
	}
else
	{
	_caja = CSATAmmoBox createVehicle _posCaja;
	_nul = [_caja] call A3A_fnc_CSATcrate;
	};
[_caja] call A3A_fnc_AIvehInit;
_caja call jn_fnc_logistics_addAction;
["LOG",[_texto,"Sea Supply",_nombredest],_posicion,"SUCCEEDED","rearm"] call A3A_fnc_taskUpdate;
[1200,"LOG"] spawn A3A_fnc_borrarTask;