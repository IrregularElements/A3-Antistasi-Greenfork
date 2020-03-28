if (!isServer and hasInterface) exitWith {false};
private ["_marcador","_base","_posbase","_posmarcador","_angOrig","_ang","_intentos","_distancia","_pos","_fallo","_mina"];

_marcador = _this select 0;

_base = _this select 1;

if (spawner getVariable _base != 2) exitWith {false};
_posbase = getMarkerPos _base;
_posmarcador = getMarkerPos _marcador;
_angOrig = _posbase getDir _posmarcador;
_ang = (_angOrig - 45) + random 90;
_intentos = 1;
//_distancia = (distanciaSPWN/2) + 101;
_distancia = if (_base in puestos) then {350} else {500};

_pos = [];
_fallo = true;
while {_intentos < 37} do
	{
	_pos = _posbase getPos [_distancia, _ang];
	if (!surfaceIsWater _pos) then
		{
		_cercano = [marcadores,_pos] call BIS_fnc_nearestPosition;
		if (spawner getVariable _cercano == 2) then
			{
			_size = [_cercano] call A3A_fnc_sizeMarker;
			if ((_pos distance (getMarkerPos _cercano)) > (_size + 100)) then
				{
				_road = [_pos,101] call BIS_fnc_nearestRoad;
				if (isNull _road) then
					{
					if ({_x distance _pos < 100} count allMines == 0) then
						{
						_fallo = false;
						};
					};
				};
			};
		};
	if (!_fallo) exitWith {};
	_intentos = _intentos + 1;
	_ang = _ang - 10;
	};

if (_fallo) exitWith {false};
_num = if (_base in puestos) then {25} else {60};
for "_i" from 1 to _num do
	{
	_mina = createMine ["APERSMine",_pos,[],100];
	(lados getVariable [_base,sideUnknown]) revealMine _mina;
	};

//[-4000] remoteExec ["resourcesAAF",2];
true