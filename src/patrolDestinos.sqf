private ["_marcadores","_array","_pos","_marcador","_destinos","_posicion","_tipo"];

_marcadores = _this select 0;
_posicion = _this select 1;
_tipo = _this select 2;
_distancia = if (_tipo == "AIR") then {distanceForAirAttack} else {distanceForLandAttack};
_array = (_marcadores - controles) select {getMarkerPos _x distance2D _posicion < _distancia};
_destinos = [];
if !(isMultiplayer) then
	{
	{
	_destino = _x;
	_pos = getMarkerPos _destino;
	if (marcadores findIf {(lados getVariable [_x,sideUnknown] == buenos) and (getMarkerPos _x distance2d _pos < _distancia)} != -1) then {_destinos pushBack _destino};
	} forEach _array;
	}
else
	{
	{
	_destino = _x;
	_pos = getMarkerPos _destino;
	if (playableUnits findIf {(side (group _x) == buenos) and (_x distance2d _pos < _distancia)} != -1) then {_destinos pushBack _destino};
	} forEach _array;
	};
_attacked = _destinos select {[_x] call BIS_fnc_taskExists};
if !(_attacked isEqualTo []) then
	{
	_destinos = (_attacked + _attacked);
	};
_destinos