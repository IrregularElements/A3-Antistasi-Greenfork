if (!isServer and hasInterface) exitWith{};

private ["_mrkOrigen","_pos","_lado","_cuenta","_mrkDestino","_veh","_posOrigen","_posDestino","_tipoVeh","_tipoMuni","_size","_vehicle","_vehCrew","_grupoVeh","_rondas","_objetivo","_objetivos"];

_mrkOrigen = _this select 0;
_posOrigen = if (_mrkOrigen isEqualType "") then {getMarkerPos _mrkOrigen} else {_mrkOrigen};
_mrkDestino = _this select 1;
_lado = _this select 2;
//_ladosMalos = _lado call BIS_fnc_enemySides;
_posDestino = getMarkerPos _mrkDestino;
_tipoVeh = if (_lado == malos) then {vehNATOMRLS} else {vehCSATMRLS};

if !([_tipoVeh] call A3A_fnc_vehAvailable) exitWith {};

_tipoMuni = if (_lado == malos) then {vehNATOMRLSMags} else {vehCSATMRLSMags};
_ladosBuenos = if (_lado == malos) then {[_lado,civilian]} else {[_lado]};
_pos = [_posOrigen, 50,100, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;

_vehicle=[_pos, random 360,_tipoveh, _lado] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
_vehCrew = _vehicle select 1;
{[_x] call A3A_fnc_NATOinit} forEach _vehCrew;
[_veh] call A3A_fnc_AIVEHinit;
_grupoVeh = _vehicle select 2;
_grupoVeh setVariable ["origen",_mrkOrigen];

_size = [_mrkDestino] call A3A_fnc_sizeMarker;

if (_posDestino inRangeOfArtillery [[_veh], ((getArtilleryAmmo [_veh]) select 0)]) then
	{
	while {(alive _veh) and ({_x select 0 == _tipoMuni} count magazinesAmmo _veh > 0) and (_mrkDestino in forcedSpawn)} do
		{
		_objetivos = _grupoVeh call A3A_fnc_enemyList;
		_grupoVeh setVariable ["objetivos",_objetivos];
		_objetos = [];
		{_objetos pushBack (_x select 4)} forEach _objetivos;
		_objetivo = objNull;
		_rondas = 1;
		_objetivosProv = _objetos select {(vehicle _x != _x) and (_x distance _posDestino <= _size * 2) and (speed _x < 1)};
		if !(_objetivosProv isEqualTo []) then
			{
			{
			if (typeOf _x in vehAttack) exitWith {_objetivo = _x; _rondas = 4};
			} forEach _objetivosProv;
			if (isNull _objetivo) then {_objetivo = selectRandom _objetivosProv};
			}
		else
			{
			_objetivosProv = _objetos select {_x distance _posDestino <= _size * 2};
			if !(_objetivosProv isEqualTo []) then
				{
				_cuenta = 0;
				{
				_posible = _x;
				if (({(side (group _x) in _ladosBuenos) and (_x distance _posible < 100)} count allUnits == 0)) then
					{
					_cuentaGrupo = {[_x] call A3A_fnc_canFight} count units group _posible;
					if (_cuentaGrupo > _cuenta) then
						{
						_objetivo = _posible;
						if (_cuentaGrupo > 6) then {_rondas = 2};
						_cuentaGrupo = _cuenta;
						};
					};
				} forEach _objetivosProv;
				};
			};
		if (!isNull _objetivo) then
			{
			_veh commandArtilleryFire [position _objetivo,_tipoMuni,_rondas];
			//_tiempo = _veh getArtilleryETA [position _objetivo, ((getArtilleryAmmo [_veh]) select 0)];
			sleep 9 + ((_rondas - 1) * 3);
			}
		else
			{
			sleep 29;
			};
		sleep 10;
		};
	};

if (!([distanciaSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _veh};

{
_veh = _x;
waitUntil {sleep 1; !([distanciaSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
deleteVehicle _veh;
} forEach _vehCrew;

deleteGroup _grupoVeh;