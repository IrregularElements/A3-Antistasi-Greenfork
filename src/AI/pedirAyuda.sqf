private ["_unit","_distancia","_hayMedico","_medico","_units","_ayudando","_pidiendoAyuda"];
_unit = _this select 0;
if (_unit getVariable ["askingForHelp",false]) exitWith {objNull};
_unit setVariable ["askingForHelp",true];
_ayudado = _unit getVariable ["ayudado",objNull];
if (!isNull _ayudado) exitWith {_unit setVariable ["askingForHelp",nil]; objNull};
_distancia = 81;
_medico = objNull;
_units = (units group _unit) select {!(isPlayer _x) and ([_x] call A3A_fnc_canFight)};
_hasFA = ("FirstAidKit" in (items _unit));
if ((_unit getVariable ["INCAPACITATED",false]) or !_hasFA) then {_units = _units - [_unit]};
if ([_unit] call A3A_fnc_fatalWound) then {_units = _units select {[_x] call A3A_fnc_isMedic}};
_units = _units select {(_x distance _unit < _distancia) and !(_x getVariable ["maniobrando",false]) and !(_x getVariable ["rearming",false]) and !(_x getVariable ["ayudando",false]) and (vehicle _x == _x)};
if !(_hasFA) then {_units = _units select {"FirstAidKit" in (items _x)}};
if (_units isEqualTo []) exitWith {_unit setVariable ["askingForHelp",nil];_medico};
{
if ([_x] call A3A_fnc_isMedic) exitWith {_medico = _x};
if (_x distance _unit <= _distancia) then
	{
	_distancia = _x distance _unit;
	_medico = _x;
	};
} forEach _units;
if !(isNull _medico) then
	{
	if (isNull(_unit getVariable ["ayudado",objNull])) then {[_unit,_medico] spawn A3A_fnc_ayudar};
	};
_unit setVariable ["askingForHelp",nil];
_medico