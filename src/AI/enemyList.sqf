private _grupo = _this;

private _lider = leader _grupo;

private _lado = side _grupo;
private _inVeh = (_lider != vehicle _lider);
private _distancia = if (_inVeh) then {distanciaSPWN} else {500};
private _enemySides = _lado call BIS_fnc_enemySides;
private _var = if (_grupo getVariable ["origen",""] != "") then {"origen"} else {if (_grupo getVariable ["marcador",""] != "") then {"marcador"} else {""}};
private _general = false;
private _dumbTime = 0;
if (time > (_grupo getVariable ["lastInfoshareGen",time - 1])) then
	{
	_general = true;
	_grupo setVariable ["lastInfoshareGen",time + 300];
	};
if (_var != "") then
	{
	_valor = _grupo getVariable _var;
	_otherGroups = if (_general) then {(allGroups select {(side _x == _lado)})-[_grupo]} else {(allGroups select {(side _x == _lado) and (_x getVariable [_var,""] == _valor)}) - [_grupo]};
	{
	_otherGroup = _x;
	{
	_eny = _x select 4;
	_knowledge = _otherGroup knowsAbout _eny;
	if (_grupo knowsAbout _eny < _knowledge) then
		{
		if (_lider distance _eny < _distancia) then
			{
			_grupo reveal [_eny,_knowledge];
			_dumbTime = _dumbTime + 1;
			};
		};
	} forEach (_otherGroup getVariable ["objetivos",[]]);
	} forEach _otherGroups;
	};
private _objetivos = (_lider nearTargets  500) select {((_x select 2) in _enemySides) and ([_x select 4] call A3A_fnc_canFight)};
_objetivos = [_objetivos,[_lider],{_input0 distance (_x select 0)},"ASCEND"] call BIS_fnc_sortBy;
_grupo setVariable ["objetivos",_objetivos];
if (_general and (vehicle _lider == _lider)) then {[_lider,_dumbTime] spawn A3A_fnc_dumbLeader};
_objetivos