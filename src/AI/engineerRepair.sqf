private _eng = _this select 0;
private _veh = _this select 1;

_eng stop false;
_eng forceSpeed -1;

waitUntil {sleep 5; ((canMove _veh) and (canFire _veh)) or !(alive _veh) or !(alive _eng)};

if (alive _eng) then {[_eng] joinSilent (_eng getVariable ["oldGroup",group _eng])};