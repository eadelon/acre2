/*
    Copyright � 2016,International Development & Integration Systems, LLC
    All rights reserved.
    http://www.idi-systems.com/

    For personal use only. Military or commercial use is STRICTLY
    prohibited. Redistribution or modification of source code is 
    STRICTLY prohibited.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
 
#include "script_component.hpp"

TRACE_1("", _this);

private["_mutex", "_lockStatus", "_remoteCall", "_locker"];
params["_caller","_object", "_mutexName"];

if( (count _this) > 3) then {
    _remoteCall = true;
} else {
    _remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
    [ACRE_EVENT(om_l), [_caller, _object, _mutexName, true] ] call CALLSTACK(LIB_fnc_globalEvent);
    LOG("Sending remote event");
    
    waitUntil { // OK
        private["_checkRet"];
        _mutex = _object getVariable _mutexName;
        _lockStatus = _mutex select 0;
        _locker = _mutex select 1;
        _checkRet = false;
        if(!(isNil "_locker")) then {
            if(_lockStatus && _locker == _caller) then {
                _checkRet = true;
            };
        };
        _checkRet
    };
    
    true
};

// object mutex are formated [status, lock_owner, objOwner]
// wait until its unlocked to destroy it
_mutex = _object getVariable _mutexName;
_lockStatus = _mutex select 0;
_locker = _mutex select 1;
TRACE_1("checking", _mutex);
if( _lockStatus ) then {
    if(_locker != _caller) then {
        waitUntil { // OK
            _mutex = _object getVariable _mutexName;
            _lockStatus = _mutex select 0;
            
            !(_lockStatus) 
        };
    };
};
LOG("UNLOCKED, LOCAL LOCKING!");

// this means the object is local to us, we create the mutex
if(!isServer) then {
    _mutex = [true, _caller, acre_player];
} else {
    _mutex = [true, _caller, GVAR(serverObject)];
};

_object setVariable [_mutexName, _mutex, true];

TRACE_1("finished", _mutex);

true