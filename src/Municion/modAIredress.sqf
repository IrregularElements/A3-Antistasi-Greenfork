private _unit = _this select 0;
private _tipo = _this select 1;

if (hayIFA) exitWith
	{
	switch (side (group _unit)) do
		{
		case malos:
			{
			switch (_tipo) do
				{
				case staticCrewMalos:
					{
					if (vehicle _unit == _unit) then
						{
						removeAllWeapons _unit;
						_unit addWeapon MGStaticNATOB;
						};
					};
				case NATOMortarMan:
					{
					_unit setUnitLoadout staticCrewMalos;
					_unit addWeapon MortStaticNATOB;
					};
				case NATOMGSupp:
					{
					_unit setUnitLoadout staticCrewMalos;
					_unit addWeapon soporteStaticNATOB2;
					};
				case NATOMortSupp:
					{
					_unit setUnitLoadout staticCrewMalos;
					_unit addWeapon soporteStaticNATOB3;
					};
				};
			};
		case muyMalos:
			{
			switch (_tipo) do
				{
				case staticCrewMuyMalos:
					{
					if (vehicle _unit == _unit) then
						{
						_unit addBackpack MGStaticCSATB;
						};
					};
				case CSATMortarMan:
					{
					_unit setUnitLoadout staticCrewMuyMalos;
					_unit addWeapon MortStaticCSATB;
					};
				case NATOMGSupp:
					{
					_unit setUnitLoadout staticCrewMuyMalos;
					_unit addBackpack soporteStaticCSATB2;
					};
				case NATOMortSupp:
					{
					_unit setUnitLoadout staticCrewMuyMalos;
					_unit addWeapon soporteStaticCSATB3;
					};
				};
			};
		};
	};