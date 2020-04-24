private ["_display","_childControl","_coste","_costeHR","_unidades","_formato"];
if (!([player] call A3A_fnc_hasRadio)) exitWith {hint "You cannot issue your required commands as there is no radio cover for proper comms. Head to one of your garrison surroundings with owned RT nearby (Outposts - Seaports - Airbases) or to your HQ surroundings in order to be able to issue orders"};
_nul = createDialog "squad_options";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	_ChildControl = _display displayCtrl 104;
	_coste = 0;
	_costeHR = 0;
	//_formato = (cfgSDKInf >> (gruposSDKSquad select 0));
	//_unidades = [_formato] call groupComposition;
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach gruposSDKSquad;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 105;
	_coste = 0;
	_costeHR = 0;
	//_formato = (cfgSDKInf >> (gruposSDKmid select 0));
	//_unidades = [_formato] call groupComposition;
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach gruposSDKSquadEng;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 106;
	_coste = 0;
	_costeHR = 0;
	//_formato = (cfgSDKInf >> (gruposSDKAT select 0));
	//_unidades = [_formato] call groupComposition;
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach gruposSDKSquadSupp;
	_coste = _coste + ([SDKMGStatic] call A3A_fnc_vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 107;
	_coste = 0;
	_costeHR = 0;
	//_unidades = [SDKSL,SDKSL];
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach gruposSDKSquadSupp;
	_coste = _coste + ([SDKMortar] call A3A_fnc_vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];
};