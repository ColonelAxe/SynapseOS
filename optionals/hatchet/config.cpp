class CfgPatches {
    class sics_hatchet {
        name = "SynapseOS - Hatchet H-60 Integration";
        author = "ATLAS Team";
        requiredVersion = 2.18;
        requiredAddons[] = {
            "sics_core",
            "vtx_uh60_config",
            "vtx_uh60_mfd",
            "HCT_interaction"
        };
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class SICS {
        class Hatchet {
            file = "\x\sics\addons\hatchet\functions";
            class hatchetOpen {};
        };
    };
};

/*
    Hatchet H-60 optional integration.
    Adds an ATLAS action to the unused 24th bezel touch point while the
    tactical map page is selected. The control opens the SynapseOS aviation
    console; Hatchet's own flight, sensor, and JVMF pages are left intact.
*/
class CfgVehicles {
    class vtx_H60_base {
        class hct_driver {
            class interaction {
                class MFD_3 {
                    class mfd_any {
                        class tac {
                            class SynapseOS_ATLAS_TAD {
                                positionType = "static";
                                position = "B_MFD3_24";
                                label = "ATLAS TAD";
                                radius = 0.015;
                                buttonUp = "call SICS_fnc_hatchetOpen";
                            };
                        };
                    };
                };

                class MFD_4 {
                    class mfd_any {
                        class tac {
                            class SynapseOS_ATLAS_TAD {
                                positionType = "static";
                                position = "B_MFD4_24";
                                label = "ATLAS TAD";
                                radius = 0.015;
                                buttonUp = "call SICS_fnc_hatchetOpen";
                            };
                        };
                    };
                };
            };
        };

        class hct_copilot {
            class interaction {
                class MFD_1 {
                    class mfd_any {
                        class tac {
                            class SynapseOS_ATLAS_TAD {
                                positionType = "static";
                                position = "B_MFD1_24";
                                label = "ATLAS TAD";
                                radius = 0.015;
                                buttonUp = "call SICS_fnc_hatchetOpen";
                            };
                        };
                    };
                };

                class MFD_2 {
                    class mfd_any {
                        class tac {
                            class SynapseOS_ATLAS_TAD {
                                positionType = "static";
                                position = "B_MFD2_24";
                                label = "ATLAS TAD";
                                radius = 0.015;
                                buttonUp = "call SICS_fnc_hatchetOpen";
                            };
                        };
                    };
                };
            };
        };
    };
};
