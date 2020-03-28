private ["_tipo","_cant"];
_tipo = _this select 0;
if (_tipo == "") exitWith {false};
if (_tipo in vehUnlimited) exitWith {true};
_cant = timer getVariable _tipo;
if (isNil "_cant") exitWith {true};
_cant = _cant - ({_x == _tipo} count vehInGarage);
if (_cant < 1) exitWith {false};
if ({typeOf _x == _tipo} count vehicles >= (floor _cant)) exitWith {false};
true