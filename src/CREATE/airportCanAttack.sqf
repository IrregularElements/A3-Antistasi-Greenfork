private _marcador = _this select 0;
if (!(_marcador in aeropuertos) and !(_marcador in puestos)) exitWith {false};
if !(dateToNumber date > server getVariable [_marcador,0]) exitWith {false};
private _minNumber = if (_this select 1) then {16} else {if (_marcador in puestos) then {24} else {32}};//si es QRF se pide un mínimo menor
if (count (garrison getVariable [_marcador,[]]) <= _minNumber) exitWith {false};
if ([distanciaSPWN/2,1,getMarkerPos _marcador,buenos] call A3A_fnc_distanceUnits) exitWith {false};
if (_marcador in forcedSpawn) exitWith {false};
true