_tiempo = _this select 0;
if (isNil "_tiempo") exitWith {};
if !(_tiempo isEqualType 0) exitWith {};
_mayor = if (_tiempo >= 3600) then {true} else {false};
_tiempo = _tiempo - (((tierWar + difficultyCoef)-1)*120);

if (_tiempo < 0) then {_tiempo = 0};

//cuentaCA = cuentaCA + round (random _tiempo);//esto está creando ataques continuos
cuentaCA = cuentaCA + _tiempo;

if (_mayor and (cuentaCA < 1200)) then {cuentaCA = 1200};
publicVariable "cuentaCA";




