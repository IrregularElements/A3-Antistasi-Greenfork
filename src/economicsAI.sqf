{
_lado = _x;
_acelerador = if (_lado == malos) then {if (tierWar == 1) then {0} else {1}} else {1.2};
_airbases = {lados getVariable [_x,sideUnknown] == _lado} count aeropuertos;
_puestos =  {lados getVariable [_x,sideUnknown] == _lado} count puestos;
_puertos = {lados getVariable [_x,sideUnknown] == _lado} count puertos;
_min = if (_airbases == 0) then {1} else {0};
//at
_maxItems = ((_puestos * 0.2) + (_airbases * 0.5)) max _min;
_tipo = if (_lado == malos) then {staticATmalos} else {staticATmuyMalos};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _acelerador),true];
	};
//aa
_maxItems = _airbases max _min;
_tipo = if (_lado == malos) then {staticAAmalos} else {staticAAmuyMalos};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.1 * _acelerador),true];
	};
//apcs
_maxItems = ((_airbases * 3) + (_puestos/3)) max _min;
_tipo = if (_lado == malos) then {vehNATOAPC} else {vehCSATAPC};
if !(_tipo isEqualTo []) then
	{
	_currentItems = 0;
	{_currentItems = _currentItems + (timer getVariable [_x,0])} forEach _tipo;
	if (_currentItems < _maxItems) then
		{
		timer setVariable [selectRandom _tipo,_currentItems + (0.2 * _acelerador),true];
		};
	};
//tanks
_maxItems = if (_lado == muyMalos) then {_airbases max _min} else {if (tierWar < 5) then {0} else {_airbases max _min}};
_tipo = if (_lado == malos) then {vehNATOTank} else {vehCSATTank};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.1 * _acelerador),true];
	};
//aaTANKS
_maxItems = if (_lado == muyMalos) then {_airbases max _min} else {if (tierWar < 3) then {0} else {_airbases max _min}};
_tipo = if (_lado == malos) then {vehNATOAA} else {vehCSATAA};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.1 * _acelerador),true];
	};
//ATTACK BOATS
_maxItems = _puertos max _min;
_tipo = if (_lado == malos) then {vehNATOBoat} else {vehCSATBoat};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.3 * _acelerador),true];
	};
//CAS PLANE
_maxItems = if (_lado == muyMalos) then {_airbases max _min} else {if (tierWar < 6) then {0} else {_airbases max _min}};
_tipo = if (_lado == malos) then {vehNATOPlane} else {vehCSATPlane};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _acelerador),true];
	};
//AA PLANE
_maxItems = if (_lado == muyMalos) then {_airbases max _min} else {if (tierWar < 4) then {0} else {_airbases max _min}};
_tipo = if (_lado == malos) then {vehNATOPlaneAA} else {vehCSATPlaneAA};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _acelerador),true];
	};
//AIR TRANSPORTS
_maxItems = (_airbases * 4) max _min;
_tipo = if (_lado == malos) then {vehNATOTransportHelis - [vehNATOPatrolHeli]} else {vehCSATTransportHelis - [vehCSATPatrolHeli]};
if !(_tipo isEqualTo []) then
	{
	_currentItems = 0;
	{_currentItems = _currentItems + (timer getVariable [_x,0])} forEach _tipo;
	if (_currentItems < _maxItems) then
		{
		timer setVariable [selectRandom _tipo,_currentItems + (0.2 * _acelerador),true];
		};
	};
//ATTACK HELIS
_maxItems = if (_lado == muyMalos) then {(2*_airbases) max _min} else {if (tierWar < 4) then {0} else {(2 * _airbases) max _min}};
_tipo = if (_lado == malos) then {vehNATOAttackHelis} else {vehCSATAttackHelis};
if !(_tipo isEqualTo []) then
	{
	_currentItems = 0;
	{_currentItems = _currentItems + (timer getVariable [_x,0])} forEach _tipo;
	if (_currentItems < _maxItems) then
		{
		timer setVariable [selectRandom _tipo,_currentItems + (0.2 * _acelerador),true];
		};
	};
//ARTY
_maxItems = _airbases;
_tipo = if (_lado == malos) then {vehNATOMRLS} else {vehCSATMRLS};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _acelerador),true];
	};
} forEach [malos,muyMalos];