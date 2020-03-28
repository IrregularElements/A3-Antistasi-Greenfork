private _grupo = group driver _this;
if (units _grupo findIf {(isPlayer _x) or ((_x getUnitTrait "engineer") and (alive _x))} != -1) exitWith {};
private _lado = side _grupo;
private _engineers = allUnits select {(side group _x == _lado) and (_x getUnitTrait "engineer") and (_x distance _veh < 300) and (local _x) and ([_x] call canFight)};
if (_engineers isEqualTo []) exitWith {};
{
if (units group _x findIf {isPlayer _x} == 0) exitWith
	{
	_x setVariable ["oldGroup",group _x];
	[_x] joinSilent _grupo;
	[_x,_veh] spawn A3A_fnc_engineerRepair
	};
} forEach _engineers;