private ["_morty0","_mortero","_pos","_tipo","_b0","_b1","_morty1"];

_grupo = _this select 0;
_morty0 = units _grupo select 0;
_morty1 = units _grupo select 1;
_tipo = _this select 1;
_b0 = MortStaticSDKB;
_b1 = soporteStaticSDKB3;
if (_tipo == SDKMGStatic) then
	{
	_b0 = MGStaticSDKB;
	_b1 = soporteStaticSDKB2;
	_morty0 setVariable ["typeOfSoldier","StaticGunner"];
	}
else
	{
	if (_tipo == staticAABuenos) then
		{
		_b0 = AAStaticSDKB;
		_b1 = soporteStaticSDKB2;
		}
	else
		{
		_morty0 setVariable ["typeOfSoldier","StaticMortar"];
		};
	};
while {(alive _morty0) and (alive _morty1)} do
	{
	waitUntil {sleep 1; ({((unitReady _x) and (alive _x))} count units _grupo == count units _grupo)};
	if ((!isNull _morty0) and (!isNull _morty1)) then
		{
		_pos = position _morty0 findEmptyPosition [1,30,_tipo];
		_mortero = _tipo createVehicle _pos;
		if (_tipo == staticAABuenos) then
			{
			_enemyPlanes = vehicles select {(side (driver _x) != buenos) and (_x isKindOf "Air")};
			if !(_enemyPlanes isEqualTo []) then
				{
				_plane = [_enemyPlanes,_mortero] call BIS_fnc_nearestPosition;
				_mortero setDir (_mortero getDir _plane);
				}
			else
				{
				_mortero setDir (getDir _morty0);
				};
			}
		else
			{
			if (hayIFA and _tipo == SDKMGStatic) then {_mortero setDir (getDir _morty0)};
			};
		if !(hayIFA) then
			{
			removeBackpackGlobal _morty0;
			removeBackpackGlobal _morty1;
			}
		else
			{
			_morty0 removeWeaponGlobal _b0;
			_morty1 removeWeaponGlobal _b1;
			};
		_grupo addVehicle _mortero;
		_morty1 assignAsGunner _mortero;
		[_morty1] orderGetIn true;
		[_morty1] allowGetIn true;
		_nul = [_mortero] call A3A_fnc_AIVEHinit;

		waitUntil {sleep 1; ({!(alive _x)} count units _grupo != 0) or !(unitReady _morty0)};

		if (({(alive _x)} count units _grupo == count units _grupo) and !(unitReady _morty0)) then
			{
			if (vehicle _morty0 != _morty0) then {_morty0 forcespeed 0};
			unassignVehicle _morty1;
			moveOut _morty1;
			deleteVehicle _mortero;
			if !(hayIFA) then
				{
				_morty0 addBackpackGlobal _b0;
				_morty1 addBackpackGlobal _b1;
				}
			else
				{
				_morty0 addWeaponGlobal _b0;
				_morty1 addWeaponGlobal _b1;
				};

			if (vehicle _morty0 != _morty0) then
				{
				waitUntil {sleep 1;(vehicle _morty0 == vehicle _morty1) or !(alive _morty0) or !(alive _morty1)};
				if (alive _morty0) then {_morty0 forcespeed -1};
				};
			};
		};
	};