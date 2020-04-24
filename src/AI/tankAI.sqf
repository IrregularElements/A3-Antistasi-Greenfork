private _veh = _this;

waitUntil {sleep 20; !(alive _veh) or (isNull _veh) or !(isNull (gunner _veh))};

if (isNull (gunner _veh)) exitWith {};

if ({isPlayer _x} count crew _veh != 0) exitWith {};
if !(canFire _veh) exitWith {};
_weapon = (weapons _veh) select 0;
while {alive _veh} do
	{
	if ({isPlayer _x} count crew _veh != 0) exitWith {};
	if !(canFire _veh) exitWith {};
	_gunner = gunner _veh;
	_grupo = group _gunner;
	if (speed _veh < 5) then
		{
		_objetivos = _grupo call A3A_fnc_enemyList;
		_grupo setVariable ["objetivos",_objetivos];
		if !(_objetivos isEqualTo []) then
			{
			_enemyInVeh = objNull;
			_enemyInBld = [];
			_checkedBlds = [];
			{
			_objetivo = _x select 4;
			if (vehicle _objetivo != _objetivo) exitWith {_enemyInVeh = _objetivo};
			if (_veh distance _objetivo < 150) then
				{
				_bld = [getPosASL _objetivo] call A3A_fnc_isBuildingPosition;
				if !(isNull _bld) then
					{
					if !(_bld in _checkedBlds) then
						{
						if (alive _bld) then
							{
							if (([_veh, "VIEW",_bld] checkVisibility [eyePos _gunner,getPosASL _bld]) > 0) then
								{
								_enemyInBld pushBack _bld;
								_checkedBlds pushBack _bld;
								}
							else
								{
								if (([_veh, "VIEW",_objetivo] checkVisibility [eyePos _gunner,eyePos _objetivo]) > 0) then
									{
									_enemyInBld pushBack _objetivo;
									_checkedBlds pushBack _bld;
									};
								};
							};
						};
					};
				};
			} forEach _objetivos;
			if (isNull _enemyInVeh) then
				{
				if !(_enemyInBld isEqualTo []) then
					{
					_bld = _enemyInBld select 0;
					_totalTime = time + 60;
					_posToCheck = if !(_bld isKindOf "BUILDING") then {eyePos _bld} else {getPosASL _bld};
					while {(alive _bld) and (alive _veh) and (canFire _veh) and (time < _totalTime) and (([_veh, "VIEW",_bld] checkVisibility [eyePos _gunner,_posToCheck]) > 0)} do
						{
						_gunner doWatch _bld;
						_tiempo = time + 15;
						waitUntil {sleep 0.5;!(alive _veh) or !(canFire _veh) or (_veh aimedAtTarget [_bld] > 0) or (time > _tiempo)};
						if (_veh aimedAtTarget [_bld] > 0) then {_veh fireAtTarget [_bld,_weapon]};
						sleep 10;
						};
					};
				};
			};
		};
	sleep 30;
	};