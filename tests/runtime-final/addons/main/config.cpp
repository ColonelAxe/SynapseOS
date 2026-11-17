class CfgPatches {class sics_test {units[]={}; weapons[]={}; requiredVersion=2.18; requiredAddons[]={"sics_core"};};};
class CfgFunctions {class SICS_TEST {class Runtime {file="\x\sics_test\addons\main"; class init {postInit=1;};};};};
class CfgMissions {class Missions {class SICS_Runtime {directory="\x\sics_test\addons\main\SICS_Runtime.VR"; briefingName="SICS v0.2 Runtime Test"; overviewText="Local UI and communications smoke test.";};};};
