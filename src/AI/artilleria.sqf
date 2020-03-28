if (!isServer and hasInterface) exitWith{};

private _mrkOrigen = _this select 0;
private _posOrigen = if (_mrkOrigen isEqualType "") then {getMarkerPos _mrkOrigen} else {_mrkOrigen};
private _mrkDestino = _this select 1;
private _lado = _this select 2;
private _tipoVeh = if (_lado == malos) then {vehNATOMRLS} else {vehCSATMRLS};
_return = [];
if !([_tipoVeh] call A3A_fnc_vehAvailable) exitWith {_return};
private _posDestino = getMarkerPos _mrkDestino;
private _pos = [_posOrigen, 50,100, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
private _vehicle=[_pos, random 360,_tipoveh, _lado] call bis_fnc_spawnvehicle;
private _veh = _vehicle select 0;
private _vehCrew = _vehicle select 1;
{[_x] call A3A_fnc_NATOinit} forEach _vehCrew;
[_veh] call A3A_fnc_AIVEHinit;
private _grupoVeh = _vehicle select 2;
_grupoVeh setVariable ["origen",_mrkOrigen];
_veh setVariable ["tipoMuni",(getArtilleryAmmo [_veh]) select 0];

if !(_posDestino inRangeOfArtillery [[_veh], ((getArtilleryAmmo [_veh]) select 0)]) exitWith
	{
	deleteVehicle _veh;
	{deleteVehicle _x} forEach _vehCrew;
	deleteGroup _grupoVeh;
	_return
	};
[_veh,_mrkDestino] spawn
	{
	private _veh = _this select 0;
	private _mrkDestino = _this select 1;
	private _size = [_mrkDestino] call A3A_fnc_sizeMarker;
	private _cuenta = 1;
	private _posDestino = getMarkerPos _mrkDestino;
	private _gunner = gunner _veh;
	private _tipoMuni = _veh getVariable ["tipoMuni",(getArtilleryAmmo [_veh]) select 0];
	while {(alive _veh) and (_cuenta < 9)} do
		{
		waitUntil {sleep 1; !(alive _veh) or (unitReady _gunner)};
		if (alive _veh) then
			{
			_veh commandArtilleryFire [_posDestino getPos [random _size,random 360],_tipoMuni,1];
			_cuenta = _cuenta + 1;
			};
		sleep 15;
		};
	};
_return = [_veh,_vehCrew,_grupoVeh];
_return