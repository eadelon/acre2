//fnc_changeState.sqf
#include "script_component.hpp"

private ["_display", "_currentState", "_editEntry"];
params["_radioId", "_state",["_menuPage",0],["_menuIndex",0],["_entryCursor",0],["_selectedEntry",-1]];

_editEntry = false;

if((count _this) > 4) then {
	_editEntry = true;
};

_currentState = ["getState", "currentState"] call GUI_DATA_EVENT;
//diag_log text format["setting last state: %1", [_currentState, PAGE_INDEX, MENU_INDEX, ENTRY_INDEX, SELECTED_ENTRY]];
[_radioId, "setState", ["lastState", [_currentState, PAGE_INDEX, MENU_INDEX, ENTRY_INDEX, SELECTED_ENTRY]]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["editEntry", _editEntry]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["currentState", _state]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["menuPage", _menuPage]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["menuIndex", _menuIndex]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["entryCursor", _entryCursor]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["selectedEntry", _selectedEntry]] call EFUNC(sys_data,dataEvent);


if(_radioId == acre_sys_radio_currentRadioDialog) then {
	_display = uiNamespace getVariable QUOTE(GVAR(currentDisplay));
	[_display] call FUNC(render);
};