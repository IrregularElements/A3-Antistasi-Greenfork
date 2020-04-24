private _unit = _this select 0;
private _grupo = group _unit;
private _lado = side _grupo;
private _posicion = position (leader _grupo);
private _result = false;
private _sitios = (puestos + puertos + aeropuertos + ["Synd_HQ"]) select {(lados getVariable [_x,SideUnknown] == _lado) and ((getMarkerPos _x) distance2D _posicion < distanciaSPWN)};
{
if (_unit inArea _x) exitWith {_result = true};
} forEach _sitios;
if (_result) exitWith {_result};
_sitios = _sitios select {([_x] call A3A_fnc_powerCheck == _lado)};
if (_lado == buenos) then
	{
	if !("Synd_HQ" in _sitios) then {if (_posicion distance2D (getMarkerPos "Synd_HQ") < distanciaSPWN) then {_sitios pushBack ["Synd_HQ"]}};
	};
if (_sitios isEqualTo []) exitWith {_result};
if (hayIFA) then
	{
	if (hayTFAR or hayACRE) then
		{
		_result = true;
		}
	else
		{
		{if ((typeOf _x in (SDKGL+["LIB_FSJ_radioman","LIB_DAK_radioman","LIB_GER_radioman","LIB_SOV_operator"])) and ([_x] call A3A_fnc_canFight)) exitWith {_result = true}} forEach (units _grupo);
		};
	}
else
	{
	if (haveRadio or hayTFAR or hayACRE) then
		{
		_result = true;
		}
	else
		{
		{if ("ItemRadio" in assignedItems _x) exitWith {_result = true}} forEach (units _grupo);
		};
	};
_result