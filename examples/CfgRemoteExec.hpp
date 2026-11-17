// Merge these into an existing mission CfgRemoteExec / Functions block.
// Do not replace the mission's other remote-execution permissions.
class CfgRemoteExec {
    class Functions {
        class SICS_fnc_server {allowedTargets = 2;};
        class SICS_fnc_receive {allowedTargets = 0;};
    };
};
