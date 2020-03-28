private _unit = _this select 0;
private _time = _this select 1;
_timeForDumb = _unit getVariable "timeForDumb";
if !(isNil "_timeForDumb") exitWith
	{
	_tiempo = _unit GetVariable "timeForDumb";
	_tiempo = _tiempo + _time;
	_unit setVariable ["timeForDumb",_tiempo];
	};
_unit setVariable ["timeForDumb",time + _time];
private _skillArray = [];
_skillNames = ["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding"];
{
_skillArray pushBack (_unit skill _x)
} forEach _skillNames;
_unit disableAI "TARGET";
waitUntil {sleep 1; (time > _unit getVariable ["timeForDumb",time-1]) or (!alive _unit)};
if !(alive _unit) exitWith {};
_unit setVariable ["timeForDumb",nil];
for "_i" from 0 to 8 do
	{
	_unit setSkill [_skillNames select _i,_skillArray select _i];
	};
_unit enableAI "TARGET";