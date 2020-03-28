private _pos = _this select 0;
private _texto = _this select 1;

_mrk = createMarker [format ["%1:%2",_texto,random 100],_pos];
_mrk setMarkerShape "ICON";
_mrk setMarkerType "hd_ambush";
_mrk setMarkerText _texto;
