private _unit = _this select 0;
private _bPos = _this select 1;
private _mgs = _this select 2;

_unit forceSpeed -1;
_unit stop false;
_unit doMove _bPos;
_unit commandMove _bPos;
_unit setDestination [_bPos, "LEADER PLANNED", true];

waitUntil {sleep 1; (!(alive _unit)) or (_unit distance _bPos < 1) or (_unit getVariable ["maniobrando",false])};
if ((!(alive _unit)) or (_unit getVariable ["maniobrando",false])) exitWith
	{
	if !(_mgs isEqualTo []) then {_mgs spawn A3A_fnc_staticMGDrill};
	};
if (_unit distance _bPos < 1) then
	{
	_unit forceSpeed 0;
	if !(_mgs isEqualTo []) then {_mgs spawn A3A_fnc_staticMGDrill};
	};