
#include "script_component.hpp"

private["_onButtonPressFunction", "_events", "_ret"];
params["_menu", "_vars"];

if(!isNil "_menu") then {
	if((count _menu) > 5) then {
		_events = MENU_ACTION_EVENTS(_menu);
		if(!isNil "_events" && _events isEqualType [] && count _events > 3) then {
			_onButtonPressFunction = MENU_ACTION_ONACTIONCOMPLETE(_menu);
			if(!isNil "_onButtonPressFunction") then {
				_ret = [_onButtonPressFunction, _menu] call FUNC(dynamicCall);
			};
		};
	};
};

if(isNil "_ret") then { _ret = false; }; 
_ret