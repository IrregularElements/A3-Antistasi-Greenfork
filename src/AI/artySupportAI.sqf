private _veh = _this select 0;
if !(alive _veh) exitWith
	{
	{if (_x getVariable ["artySupport",objNull] == _veh) then {_x setVariable ["artySupport",objNull]}} forEach allGroups;
	};
private _gunner = gunner _veh;
if (isNull _gunner) exitWith
	{
	{if (_x getVariable ["artySupport",objNull] == _veh) then {_x setVariable ["artySupport",objNull]}} forEach allGroups;
	};
//private _lado = side (group _gunner);
private _tipoMuni = _veh getVariable ["tipoMuni",(getArtilleryAmmo [_veh]) select 0];
if ({_x select 0 == _tipoMuni} count magazinesAmmo _veh == 0) exitWith
	{
	{if (_x getVariable ["artySupport",objNull] == _veh) then {_x setVariable ["artySupport",objNull]}} forEach allGroups;
	};
if !(unitReady _gunner) exitWith {};
if (_veh getVariable ["busy",false]) exitWith {};
_veh setVariable ["busy",true];
_veh commandArtilleryFire [_this select 1,_tipoMuni,_this select 2];
sleep 10;
_veh setVariable ["busy",false];