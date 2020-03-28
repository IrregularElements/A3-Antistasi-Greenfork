//ejemplo: _result = [distanciaSPWN,0,posHQ,muyMalos] call A3A_fnc_distanceUnits: devuelve un array con todas las que estén a menos de distanciaSPWN
//ejemplo: _result = [distanciaSPWN,1,posHQ,buenos] call A3A_fnc_distanceUnits: devuelve un boolean si hay una que esté a menos de distanciaSPWN
params ["_distancia","_modo","_referencia","_variable"];

_distancia = _this select 0;//la distancia requisito, normalmente distanciaSPWN)
_modo = _this select 1;//lo que devuelve la función, 0 un array, un número mayor un boolean cuando la cuenta llegue a ese número.
_referencia = _this select 2; // posición en formato array u objeto
_variable = _this select 3;//side
if !(_variable isEqualType []) then {_variable = [_variable]};
private _result = false;
private _allUnits = allUnits select {(_x getVariable ["spawner",false]) and ((side group _x) in _variable) and (_x distance2D _referencia < _distancia)};
if (_modo == 0) then
	{
	_result = _allUnits
	}
else
	{
	_result = !(_allUnits isEqualTo []);
	};

_result
