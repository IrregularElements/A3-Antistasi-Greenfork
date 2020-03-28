private _pos = _this;
private _bestPlaces = selectBestPlaces [_pos, 50, "(1 + houses) * (1 + hills) * (1 - sea)", 10, 5];
private _highest = [];
private _altura = 0;
{
_tmpPos = _x select 0;
if !(surfaceIsWater _tmpPos) then
	{
	if (getTerrainHeightASL _tmpPos >= _altura) then
		{
		_altura = getTerrainHeightASL _tmpPos;
		_highest = _tmpPos;
		};
	};
} forEach _bestPlaces;
_tmpPos = if !(_highest isEqualTo []) then {_highest findEmptyPosition [1,50,SDKUnarmed]} else {[]};
if !(_tmpPos isEqualTo []) then {_highest = _tmpPos};
_highest