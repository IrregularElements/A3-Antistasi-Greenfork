private _pos = _this select 0;
private _dir = _this select 1;
private _posRef = ATLtoASL [_pos select 0,_pos select 1,(_pos select 2) + 1.5];
private _posRefFloor = ATLtoASL [_pos select 0,_pos select 1,(_pos select 2) + 0.3];
private _return = [];
for "_i" from 0 to 3 do
	{
	_exit = true;
	_dir = _dir + (90*_i);
	_posPrueba = _posRefFloor getPos [25,_dir];
	_posPrueba set [2,_posRefFloor select 2];
	_los = lineIntersectsWith [_posRefFloor,_posPrueba];
	if !(_los isEqualTo []) then
		{
		if (_los select 0 isKindOf "BUILDING") then
			{
			_posPrueba = _posRef getPos [25,_dir];
			_posPrueba set [2,_posRef select 2];
			_los = lineIntersectsWith [_posRef,_posPrueba];
			if !(_los isEqualTo []) then
				{
				if (_los select 0 isKindOf "BUILDING") then {_exit = false};
				};
			}
		else
			{
			_exit = false;
			};
		};
	//diag_log format ["Posicion:%1. Dir:%2. Pos Ref:%3. posPrueba:%4 Los:%5 Es ventana:%6",_pos,_dir,_posRef,_posPrueba,_los,_exit];
	if (_exit) exitWith {_return = [_pos,_dir]};
	};
_return