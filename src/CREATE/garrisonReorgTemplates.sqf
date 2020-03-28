private _garrison = +_this select 0;
if (count _garrison <= 8) exitWith
	{
	_return = _garrison call A3A_fnc_garrisonReorg;
	_return
	};
private _lado = _this select 1;
private _return = [];
private _subReturn = [];
private _template = if (_lado == malos) then {NATOSquad} else {CSATSquad};//main group, which will be fortified
{
_type = _x;
_index = _garrison findIf {_type == _x};
if (_index != -1) then
	{
	_subReturn pushBack _x;
	_garrison deleteAT _index;
	};
} forEach _template;
if !(_subReturn isEqualTo []) then {_return pushBack _subReturn};
if (count _garrison <= 8) exitWith
	{
	if !(_garrison isEqualTo []) then
		{
		_subReturn = _garrison call A3A_fnc_garrisonReorg;
		{
		_return pushBack _x;
		} forEach _subReturn;
		};
	_return
	};

_subreturn = [];
private _tipo = if (_lado == malos) then {NATOEngineer} else {CSATEngineer};//engineer group
_template = if (_lado == malos) then {NATOSquadEng} else {CSATSquadEng};
while {_tipo in _garrison} do
	{
	{
	_type = _x;
	_index = _garrison findIf {_type == _x};
	if (_index != -1) then
		{
		_subReturn pushBack _x;
		_garrison deleteAT _index;
		};
	} forEach _template;
	_return pushBack _subReturn;
	_subreturn = [];
	};
if (count _garrison <= 8) exitWith
	{
	if !(_garrison isEqualTo []) then
		{
		_subReturn = _garrison call A3A_fnc_garrisonReorg;
		{
		_return pushBack _x;
		} forEach _subReturn;
		};
	_return
	};

_subreturn = [];
_tipo = if (_lado == malos) then {NATOMortarMan} else {CSATMortarMan};//mortar group
private _subTipo = if (_lado == malos) then {NATOMortSupp} else {CSATMortSupp};
_template = if (_lado == malos) then {NATOSquadMortar} else {CSATSquadMortar};
while {(_tipo in _garrison) and (_subTipo in _garrison)} do
	{
	{
	_type = _x;
	_index = _garrison findIf {_type == _x};
	if (_index != -1) then
		{
		_subReturn pushBack _x;
		_garrison deleteAT _index;
		};
	} forEach _template;
	_return pushBack _subReturn;
	_subreturn = [];
	};
if (count _garrison <= 8) exitWith
	{
	if !(_garrison isEqualTo []) then
		{
		_subReturn = _garrison call A3A_fnc_garrisonReorg;
		{
		_return pushBack _x;
		} forEach _subReturn;
		};
	_return
	};

_subreturn = [];
_tipo = if (_lado == malos) then {staticCrewMalos} else {staticCrewMuyMalos};//mg static group
_subTipo = if (_lado == malos) then {NATOMGSupp} else {CSATMGSupp};
_template = if (_lado == malos) then {NATOSquadMG} else {CSATSquadMG};
while {(_tipo in _garrison) and (_subTipo in _garrison)} do
	{
	{
	_type = _x;
	_index = _garrison findIf {_type == _x};
	if (_index != -1) then
		{
		_subReturn pushBack _x;
		_garrison deleteAT _index;
		};
	} forEach _template;
	_return pushBack _subReturn;
	_subreturn = [];
	};
if (count _garrison <= 8) exitWith
	{
	if !(_garrison isEqualTo []) then
		{
		_subReturn = _garrison call A3A_fnc_garrisonReorg;
		{
		_return pushBack _x;
		} forEach _subReturn;
		};
	_return
	};

_subreturn = [];
_tipo = if (_lado == malos) then {NATOAT} else {CSATAT};//AT group
_template = if (_lado == malos) then {NATOSquadAT} else {CSATSquadAT};
while {_tipo in _garrison} do
	{
	{
	_type = _x;
	_index = _garrison findIf {_type == _x};
	if (_index != -1) then
		{
		_subReturn pushBack _x;
		_garrison deleteAT _index;
		};
	} forEach _template;
	_return pushBack _subReturn;
	_subreturn = [];
	};
if (count _garrison <= 8) exitWith
	{
	if !(_garrison isEqualTo []) then
		{
		_subReturn = _garrison call A3A_fnc_garrisonReorg;
		{
		_return pushBack _x;
		} forEach _subReturn;
		};
	_return
	};

_subreturn = [];
_tipo = if (_lado == malos) then {NATOAA} else {CSATAA};//AA group
_template = if (_lado == malos) then {NATOSquadAA} else {CSATSquadAA};
while {_tipo in _garrison} do
	{
	{
	_type = _x;
	_index = _garrison findIf {_type == _x};
	if (_index != -1) then
		{
		_subReturn pushBack _x;
		_garrison deleteAT _index;
		};
	} forEach _template;
	_return pushBack _subReturn;
	_subreturn = [];
	};
if (count _garrison <= 8) exitWith
	{
	if !(_garrison isEqualTo []) then
		{
		_subReturn = _garrison call A3A_fnc_garrisonReorg;
		{
		_return pushBack _x;
		} forEach _subReturn;
		};
	_return
	};


_template = if (_lado == malos) then {NATOSquad} else {CSATSquad};
private _otherUnits = _garrison select {!(_x in _template)};//units belonging to other factions out of the templates
if !(_otherUnits isEqualTo []) then
	{
	_garrison = _garrison - _otherUnits;
	_otherUnits = _otherUnits call A3A_fnc_garrisonReorg;
	};
_subReturn = [];
while {count _garrison >= 8} do
	{
	{
	_type = _x;
	_index = _garrison findIf {_type == _x};
	if (_index != -1) then
		{
		_subReturn pushBack _x;
		_garrison deleteAT _index;
		};
	} forEach _template;
	if !(_subReturn isEqualTo []) then
		{
		_return pushBack _subReturn;
		_subreturn = [];
		};
	};

if !(_garrison isEqualTo []) then
	{
	_subReturn = _garrison call A3A_fnc_garrisonReorg;
	{
	_return pushBack _x;
	} forEach _subReturn;
	};
if !(_otherUnits isEqualTo []) then
	{
	{
	_return pushBack _x;
	} forEach _otherUnits;
	};
_return