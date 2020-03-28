private _grupo = _this;
private _unidades = units _grupo;
while {{alive _x} count _unidades > 0} do
	{
	sleep 30;
	_grupo call A3A_fnc_enemyList
	};