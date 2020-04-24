private ["_pos","_cuenta","_sonda","_intersec","_zi","_zf"];
_pos = _this select 0;
_pos = _pos findEmptyPosition [1,30,"I_G_Mortar_01_F"];
if (count _pos == 0) then {_pos = _this select 0};
_cuenta = 300;
while {_cuenta > 0} do
	{
	if !(isNull ([_pos] call A3A_fnc_isBuildingPosition)) then {_exit = true};
	_pos = _pos getPos [31,random 360];
	_cuenta = _cuenta - 1;
	};
if (_cuenta == 0) then {_pos = (_this select 0) findEmptyPosition [1,30,"I_G_Mortar_01_F"]};
if (_pos isEqualTo []) then {_pos = _this select 0};

_pos