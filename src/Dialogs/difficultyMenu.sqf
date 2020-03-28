_nul=createDialog "diff_menu";
waitUntil {dialog};
hint "Choose a difficulty level";
waitUntil {!dialog};
if !(skillMult == 1) then
	{
	if (skillMult == 0.5) then
		{
		server setVariable ["hr",25,true];
		server setVariable ["resourcesFIA",5000,true];
		vehInGarage = [vehSDKTruck,vehSDKTruck,SDKMortar,SDKMGStatic,staticAABuenos];
		minWeaps = 15;
		_index = sniperRifle call jn_fnc_arsenal_itemType;
		[_index,sniperRifle,-1] call jn_fnc_arsenal_addItem;
		unlockedSN pushBack sniperRifle;
		_magazine = (getArray (configFile / "CfgWeapons" / sniperRifle / "magazines") select 0);
		if (!isNil "_magazine") then
			{
			unlockedMagazines pushBack _magazine;
			_index = _magazine call jn_fnc_arsenal_itemType;
			[_index,_magazine,-1] call jn_fnc_arsenal_addItem;
			};
		unlockedWeapons pushBack sniperRifle;
		if !(hayTFAR) then
			{
			_index = "ItemRadio" call jn_fnc_arsenal_itemType;
			[_index,"ItemRadio",-1] call jn_fnc_arsenal_addItem;
			unlockedItems pushBack "ItemRadio";
			haveRadio = true;
			};
		}
	else
		{
		server setVariable ["hr",0,true];
		server setVariable ["resourcesFIA",200,true];
		minWeaps = 40;
		};
	[] call A3A_fnc_statistics;
	};
_nul= createDialog "gameMode_menu";
waitUntil {dialog};
hint "Choose a Game Mode";
waitUntil {!dialog};
if (gameMode != 1) then
	{
	malos setFriend [muyMalos,1];
    muyMalos setFriend [malos,1];
    if (gameMode == 3) then {"CSAT_carrier" setMarkerAlpha 0};
    if (gameMode == 4) then {"NATO_carrier" setMarkerAlpha 0};
    if (!hayIFA) then
		{
		if (activeUSAF) then
			{
			if (buenos != independent) then {call compile preProcessFileLineNumbers "Templates\buenosRHSUSAF.sqf"};
			};
		if (!activeGREF) then
			{
			call compile preProcessFileLineNumbers "Templates\buenosVanilla.sqf"
			}
		else
			{
			if (buenos == independent) then {call compile preProcessFileLineNumbers "Templates\buenosRHSGREF.sqf"};
			};
		}
	else
		{
		call compile preProcessFileLineNumbers "Templates\buenosIFA.sqf";
		};
	squadLeaders pushBack (FIASquad select 0);
	medics pushBack (FIAsquad select ((count FIAsquad)-1));
	vehNormal pushBack vehFIATruck;
	vehTrucks pushBack vehFIATruck;
	sniperUnits pushBack FIAMarksman;
	};
switch (gameMode) do
	{
	case 1: {player createDiaryRecord ["Diary",["AI RoE",format ["All vs All war.<br/><br/>%1 and %2 will attack each other and both to %3.",nameMalos,nameMuyMalos,nameBuenos]]]};
	case 2: {player createDiaryRecord ["Diary",["AI RoE",format ["%3 vs All war.<br/><br/>%1 and %2 will attack only %3 and act independently. Both can conquer.",nameMalos,nameMuyMalos,nameBuenos]]]};
	case 3: {player createDiaryRecord ["Diary",["AI RoE",format ["%2 vs %1 war.",nameMalos,nameBuenos]]]};
	case 4: {player createDiaryRecord ["Diary",["AI RoE",format ["%2 vs %1 war.",nameMuyMalos,nameBuenos]]]};
	};
hint "Map Init in progress";
call compile preprocessFileLineNumbers "initGarrisons.sqf";
hint "Map Init Done";
_nul = [] spawn A3A_fnc_placementselection;