private ["_tipo","_coste","_posicionTel","_cantidad","_cantidadMax"];

if (["Mines"] call BIS_fnc_taskExists) exitWith {hint "We can only deploy one minefield at a time."};

if (!([player] call A3A_fnc_hasRadio)) exitWith {hint "You cannot issue your required commands as there is no radio cover for proper comms. Head to one of your garrison surroundings with owned RT nearby (Outposts - Seaports - Airbases) or to your HQ surroundings in order to be able to issue orders"};

_tipo = _this select 0;

_coste = (2*(server getVariable (SDKExp select 0))) + ([vehSDKTruck] call A3A_fnc_vehiclePrice);
_hr = 2;
if (_tipo == "delete") then
	{
	_coste = _coste - (server getVariable (SDKExp select 0));
	_hr = 1;
	};
if ((server getVariable "resourcesFIA" < _coste) or (server getVariable "hr" < _hr)) exitWith {hint format ["Not enought resources to recruit a mine deploying team (%1 € and %2 HR needed)",_coste,_hr]};

if (_tipo == "delete") exitWith
	{
	hint "Explosive Specialists is available on your High Command bar.\n\nSend him anywhere on the map and he will deactivate and load in his truck any mine he may find.\n\nReturning back to HQ will unload the mines he stored in his vehicle";
	[[],"A3A_fnc_mineSweep"] remoteExec ["A3A_fnc_scheduler",2];
	};

#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

_pool = jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT;
_cantidad = 0;
_cantidadMax = 40;
_tipoM =APERSMineMag;
if (_tipo == "ATMine") then
	{
	_cantidadMax = 20;
	_tipoM = ATMineMag;
	};

{
if (_x select 0 == _tipoM) exitWith {_cantidad = _x select 1}
} forEach _pool;

if (_cantidad < 5) exitWith {hint "You need at least 5 mines of this type to build a Minefield"};

if (!visibleMap) then {openMap true};
posicionTel = [];
hint "Click on the position you wish to build the minefield.";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;

if (_cantidad > _cantidadMax) then
	{
	_cantidad = _cantidadMax;
	};

[[_tipo,_posicionTel,_cantidad],"A3A_fnc_buildMinefield"] remoteExec ["A3A_fnc_scheduler",2];