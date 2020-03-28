private ["_marcador","_posicion","_mrkENY","_return"];

_marcador = _this select 0;
//_isfrontier = false;

_lado = lados getVariable [_marcador,sideUnknown];
_posicion = getMarkerPos _marcador;
_return = [];
_mrkENY = (aeropuertos + puestos + puertos) select {(lados getVariable [_x,sideUnknown] != _lado) and (getMarkerPos _x distance2D _posicion < distanceForLandAttack)};
/*
if (count _mrkENY > 0) then
	{
	_posicion = getMarkerPos _marcador;
	{if (_posicion distance (getMarkerPos _x) < distanciaSPWN) exitWith {_isFrontier = true}} forEach _mrkENY;
	};
_isfrontier
*/
if !(_mrkENY isEqualTo []) then {_return = [_mrkENY,[],{_posicion distance (getMarkerPos _x)},"ASCEND"] call BIS_fnc_sortBy};
_return