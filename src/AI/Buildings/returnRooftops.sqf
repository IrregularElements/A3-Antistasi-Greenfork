private _pos = _this select 0;
private _num = _this select 1;
private _edificios = nearestObjects [_pos, ["house","building"], (50 +random 25)];
private _posiciones = [];
private _ventanas = [];
private _lim = 0;
if !(_edificios isEqualTo []) then
	{
	_edificios = _edificios call BIS_fnc_arrayShuffle;
	{
	_dir = getDir _x;
	_bldPos = _x buildingPos - 1;
	if !(_bldPos isEqualTo []) then
		{
		for "_i" from 0 to (count _bldPos) -1 do
			{
			_posicion = _bldPos select _i;
			_nearEntities = _posicion nearEntities ["Man",1];
			if (_nearEntities isEqualTo []) then
				{
				if ((_posicion select 2) > 1.8) then
					{
					if ([_posicion] call A3A_fnc_isInRoof) then
						{
						_posiciones pushback _posicion;
						_lim = _lim +1;
						}
					else
						{
						_ventana = [_posicion,_dir] call A3A_fnc_isWindowed;
						if !(_ventana isEqualTo []) then {_ventanas pushback _ventana};
						};
					}
				else
					{
					_ventana = [_posicion,_dir] call A3A_fnc_isWindowed;
					if !(_ventana isEqualTo []) then {_ventanas pushback _ventana};
					};
				};
			};
		};
	if (_lim >= _num) exitWith {};
	} forEach _edificios;
	};
if !(_posiciones isEqualTo []) then
	{
	_posiciones = [_posiciones,[],{getTerrainHeightASL _x},"DESCEND"] call BIS_fnc_sortBy;
	};
if !(_ventanas isEqualTo []) then
	{
	_ventanas = _ventanas call BIS_fnc_arrayShuffle;
	};
[_posiciones,_ventanas]