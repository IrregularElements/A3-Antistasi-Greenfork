/****************************************************************
File: UPSMON_Inbuilding.sqf modified by Barbolani
Author: Azroul13

Description:
	 Check if the AI is in a building.

Parameter(s):
	<--- Unit
Returns:
	boolean
****************************************************************/

private ["_Inbuilding","_Roof","_pos","_Down"];
_pos = _this select 0;
if ((_pos select 2) == 0) then {_pos = ATLtoASL _pos};
_Inbuilding = objNull;
_Down = lineIntersectsWith [_pos, [(_pos select 0), (_pos select 1), (_pos select 2) - 20]];

if !(_Down isEqualTo []) then
	{
	if ((_Down select 0) isKindOf "BUILDING") then {_InBuilding = _Down select 0};
	};

if (isNull _Inbuilding) then
{
	_Roof = lineIntersectsWith [_pos, [(_pos select 0), (_pos select 1), (_pos select 2) + 20]];
	if !(_Roof isEqualTo []) then
	{
	if ((_Roof select 0) isKindOf "BUILDING") then {_InBuilding = _roof select 0};
	};
};

_Inbuilding