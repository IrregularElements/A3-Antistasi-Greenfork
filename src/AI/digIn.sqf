private _grupo = _this select 0;
private _spawned = _this select 1;//determina si debemos teletransportar cosas o dejarlas hechas
_grupo setVariable ["attackDrill",false];
private _lado = side _grupo;
private _friendlies = if ((_lado == malos) or (_lado == buenos)) then {[_lado,civilian]} else {[_lado]};
private _marcador = (leader _grupo) getVariable ["marcador",""];
private _posRef = if (_marcador == "") then {[0,0,0]} else {getMarkerPos _marcador};
private _posToDefend = getPosASL (leader _grupo);
_morteros = [];
_mgs = [];

_medics = [];
_engineers = [];
_SMGs = [];
_snipers = [];
_supporters = [];
private _doTakeCover = units _grupo;
private _firstInit = true;
{
if (alive _x) then
	{
	_result = _x call A3A_fnc_typeOfSoldier;
	_x setVariable ["maniobrando",false];
	//_x disableAI "TARGET";
	switch (_result) do
		{
		//case "Normal": {_baseOfFire pushBack _x};
		case "StaticMortar": {_morteros pushBack _x};
		case "StaticGunner": {_mgs pushBack _x};
		case "Medic": {_medics pushBack _x};
		case "Engineer": {_engineers pushBack _x};
		case "MGMan": {_SMGs pushBack _x};
		case "Sniper": {_snipers pushBack _x};
		case "StaticBase": {_supporters pushBack _x};
		};
	};
} forEach (units _grupo);
if (!(_morteros isEqualTo []) and !(_supporters isEqualTo [])) then
	{
	_num = ((count _morteros) min (count _supporters)) -1;
	//_morteros append ((units _grupo) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	//if (count _morteros > _num) then
	for "_i" from 0 to _num do
		{
		_relDir = _posToDefend getDir _posRef;
		_relPos = _posToDefend getPos [25,_relDir];
		_doTakeCover = _doTakeCover - _morteros;
		if (_spawned) then
			{
			(_morteros select _i) setPos _relPos;
			[_morteros select _i,_supporters select _i] spawn A3A_fnc_staticMGDrill;
			}
		else
			{
			[_morteros select _i,_supporters select _i] spawn A3A_fnc_staticMGDrill;
			};
		_supporters deleteRange [0,_num];
		};
	for "_i" from (_num + 1) to (count _morteros) - 1 do
		{
		(_morteros select _i) setVariable ["typeOfSoldier","Normal"];
		};
	_morteros deleteRange [_num,count _morteros];
	}
else
	{
	{_x setVariable ["typeOfSoldier","Normal"]} forEach _morteros;
	_morteros = [];
	};

if (_spawned) then
	{
	_wp = _grupo addWaypoint [_posToDefend,0];
	_wp setWaypointType "MOVE";
	};
private _buildingPos = [_posToDefend,count units _grupo] call A3A_fnc_returnRooftops;
private _rooftops = _buildingPos select 0;
private _windows = _buildingPos select 1;
if (!(_mgs isEqualTo []) and !(_supporters isEqualTo [])) then
	{
	_num = ((count _mgs) min (count _supporters)) -1;
	for "_i" from 0 to _num do
		{
		_destino = [];
		_dir = getDir (_mgs select _i);
		_mg = _mgs select _i;
		_sup = _supporters select _i;
		_doTakeCover = _doTakeCover - [_mgs select _i] - [_supporters select _i];
		if !(_rooftops isEqualTo []) then
			{
			_destino = _rooftops select 0;
			_rooftops deleteAt 0;
			}
		else
			{
			if !(_windows isEqualTo []) then
				{
				_destino = (_windows select 0) select 0;
				_dir = (_windows select 0) select 1;
				_windows deleteAt 0;
				};
			};
		if (_spawned) then
			{
			if !(_destino isEqualTo []) then
				{
				_mg setPosATL _destino;
				doStop _mg;
				_mg setDir _dir;
				[_mg,_sup] spawn A3A_fnc_staticMGDrill;
				}
			else
				{
				[_mg,_sup] spawn A3A_fnc_staticMGDrill;
				};
			}
		else
			{
			if !(_destino isEqualTo []) then
				{
				[_mg,_destino,[_mg,_sup]] spawn A3A_fnc_moveToBuildingPos;
				}
			else
				{
				[_mg,_sup] spawn A3A_fnc_staticMGDrill;
				};
			};
		};
	for "_i" from (_num+1) to (count _mgs) - 1 do
		{
		(_mgs select _i) setVariable ["typeOfSoldier","Normal"];
		};
	for "_i" from (_num+1) to (count _supporters) - 1 do
		{
		(_supporters select _i) setVariable ["typeOfSoldier","Normal"];
		};
	_mgs deleteRange [(_num+1),count _mgs];
	_supporters deleteRange [(_num+1),count _supporters];
	}
else
	{
	{_x setVariable ["typeOfSoldier","Normal"]} forEach (_mgs + _supporters);
	_mgs = [];
	_supporters = [];
	};
{
if ((_rooftops isEqualTo []) and (_windows isEqualTo [])) exitWith {};
_destino = [];
_dir = getDir _x;
_doTakeCover = _doTakeCover - [_x];
if !(_rooftops isEqualTo []) then
	{
	_destino = _rooftops select 0;
	_rooftops deleteAt 0;
	}
else
	{
	_destino = (_windows select 0) select 0;
	_dir = (_windows select 0) select 1;
	_windows deleteAt 0;
	};
if (_spawned) then
	{
	_x setPosATL _destino;
	_x forceSpeed 0;
	doStop _x;
	_x setDir _dir;
	}
else
	{
	[_x,_destino,[]] spawn A3A_fnc_moveToBuildingPos;
	};
} forEach (_snipers + _SMGs);
{
if ((_rooftops isEqualTo []) and (_windows isEqualTo [])) exitWith {};
_destino = [];
_dir = getDir _x;
_doTakeCover = _doTakeCover - [_x];
if !(_rooftops isEqualTo []) then
	{
	_destino = _rooftops select 0;
	_rooftops deleteAt 0;
	}
else
	{
	_destino = (_windows select 0) select 0;
	_dir = (_windows select 0) select 1;
	_windows deleteAt 0;
	};
if (_spawned) then
	{
	_x setPosATL _destino;
	_x forceSpeed 0;
	doStop _x;
	_x setDir _dir;
	}
else
	{
	[_x,_destino,[]] spawn A3A_fnc_moveToBuildingPos;
	};
} forEach ((units _grupo) - (_snipers + _SMGs + _mgs + _morteros + _medics + _engineers));

{
_relPos = [_x,_posToDefend] call A3A_fnc_cobertura;
if !(_relPos isEqualTo []) then
	{
	if (_spawned) then
		{
		_x setPosATL _relPos;
		_x forceSpeed 0;
		}
	else
		{
		[_x,_relPos,[]] spawn A3A_fnc_moveToBuildingPos;
		};
	};
} forEach _doTakeCover;

while {({alive _x} count units _grupo > 0) and !(_grupo getVariable ["attackDrill",false])} do
	{
	_objetivos = _grupo call A3A_fnc_enemyList;
	_grupo setVariable ["objetivos",_objetivos];
	_posToDefend = getPosASL (leader _grupo);
	_hasRadio = [leader _grupo] call A3A_fnc_hasRadio;
	_lider = leader _grupo;
	if !(_objetivos isEqualTo []) then
		{
		_aire = objNull;
		_tanques = objNull;
		{
		_eny = assignedVehicle (_x select 4);
		if (_eny isKindOf "Tank") then
			{
			_tanques = _eny;
			}
		else
			{
			if (_eny isKindOf "Air") then
				{
				if (count (weapons _eny) > 1) then
					{
					_aire = _eny;
					};
				};
			};
		if (!(isNull _aire) and !(isNull _tanques)) exitWith {};
		} forEach _objetivos;

		_allNearFriends = allUnits select {(_x distance _lider < (distanciaSPWN/2)) and (side group _x in _friendlies)};

		_numNearFriends = count _allNearFriends;
		_numObjetivos = count _objetivos;
		_cercano = _grupo call A3A_fnc_enemigoCercano;
		_soldados = ((units _grupo) select {[_x] call A3A_fnc_canFight}) - [_grupo getVariable ["mortero",objNull]];
		_numSoldados = count _soldados;
		if !(isNull _aire) then
			{
			if (_allNearFriends findIf {(_x call A3A_fnc_typeOfSoldier == "AAMan") or (_x call A3A_fnc_typeOfSoldier == "StaticGunner")} == -1) then
				{
				if ((_lado != buenos) and _hasRadio) then {[[getPosASL _lider,_lado,"Air",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
				};
			};
		if !(isNull _tanques) then
			{
			if (_allNearFriends findIf {_x call A3A_fnc_typeOfSoldier == "ATMan"} == -1) then
				{
				_mortero = _grupo getVariable ["morteros",objNull];
				if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
					{
					if ({if (_x distance _tanques < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _tanques,4] spawn A3A_fnc_mortarSupport};
					}
				else
					{
					if ((_lado != buenos) and _hasRadio) then {[[getPosASL _lider,_lado,"Tank",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
					};
				};
			};
		if (_numObjetivos > 2*_numNearFriends) then
			{
			if !(isNull _cercano) then
				{
				if ((_lado != buenos) and _hasRadio) then {[[getPosASL _lider,_lado,"Normal",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
				_mortero = _grupo getVariable ["morteros",objNull];
				if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
					{
					if ({if (_x distance _cercano < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _cercano,1] spawn A3A_fnc_mortarSupport};
					};
				};
			};
		if !(isNull _cercano) then
			{
			if ((_cercano distance _posRef) < ((_posToDefend distance _posRef)/2)) then
				{
				_grupo call A3A_fnc_recallGroup;
				_relDir = _posRef getDir _cercano;
				_relPos = _posRef getPos [((_cercano distance _posRef)/2),_relDir];
				_wp = _grupo addWaypoint [_relPos,0];
				_wp setWaypointType "MOVE";
				_wp setWaypointStatements ["true","[(group this),false] spawn A3A_fnc_digIn"];
				_grupo spawn A3A_fnc_attackDrillAI;
				}
			else
				{
				if (_firstInit) then
					{
					_distancia = _cercano distance _posToDefend;
					_firstInit = false;
					if (_distancia > 500) then
						{
						if (isNull _tanques) then
							{
							{[_x,_cercano] spawn A3A_fnc_placeMines} forEach (_engineers select {[_x] call A3A_fnc_canFight});
							};
						}
					else
						{
						{_x call A3A_fnc_recallGroup} forEach (units _grupo select {!(isNull([getPosASL _x] call A3A_fnc_isBuildingPosition))});
						};
					if (sunOrMoon < 1) then
						{
						if !(haveNV) then
							{
							if (hayIFA) then
								{
								if (([_lider] call A3A_fnc_canFight) and ((typeOf _lider) in squadLeaders)) then {[_lider,_lider] call A3A_fnc_useFlares}
								}
							else
								{
								{
								[_x,_x] call A3A_fnc_useFlares;
								} forEach _baseOfFire select {(_x getVariable ["typeOfSoldier",""] == "Normal") and (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)};
								};
							};
						};
					};
				};
			};
		}
	else
		{
		if (sunOrMoon < 1) then
			{
			if !(haveNV) then
				{
				if (random 10 < 2) then
					{
					if (hayIFA) then
						{
						if (([_lider] call A3A_fnc_canFight) and ((typeOf _lider) in squadLeaders)) then {[_lider,_lider] call A3A_fnc_useFlares}
						}
					else
						{
						{
						[_x,_x] call A3A_fnc_useFlares;
						} forEach _baseOfFire select {(_x getVariable ["typeOfSoldier",""] == "Normal") and (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)};
						};
					};
				};
			};
		};
	sleep 30;
	};