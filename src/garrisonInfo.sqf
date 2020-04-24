private ["_sitio","_texto","_garrison","_size","_posicion"];

_sitio = _this select 0;

_garrison = garrison getVariable [_sitio,[]];

_size = [_sitio] call A3A_fnc_sizeMarker;
_posicion = getMarkerPos _sitio;
_estatic = if (_sitio in puestosFIA) then {"Technicals"} else {"Mortars"};
_grenadiers = if (hayIFA) then {"Radio Operators"} else {"Grenadiers"};
_texto = format ["\n\nGarrison men: %1\n\nSquad Leaders: %2\n%11: %3\nRiflemen: %4\nAutoriflemen: %5\nMedics: %6\n%12: %7\nMarksmen: %8\nAT Men: %9\nStatic Weap: %10", count _garrison, {_x in SDKSL} count _garrison, ({_x == staticCrewBuenos} count _garrison) + ({(_x isKindOf "StaticMortar") and (_x inArea _sitio) and (_x getVariable ["staticsToSave",false])} count vehicles), {_x in SDKMil} count _garrison, {_x in SDKMG} count _garrison,{_x in SDKMedic} count _garrison,{_x in SDKGL} count _garrison,{_x in SDKSniper} count _garrison,{_x in SDKATman} count _garrison, {!(_x isKindOf "StaticMortar") and (_x inArea _sitio) and (_x getVariable ["staticsToSave",false])} count vehicles, _estatic,_grenadiers];

_texto