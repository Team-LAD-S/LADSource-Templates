local MovesetName = "COMPLEX_MOVESET_TEMPLATE" -- Moveset name, you will use this to reference the moveset in code
local MovesetTable = {
    ["MovesetProperties"] = {
        Icon = "player/kiryu_0_b.png",                      -- Style icon (appears in Yakuza 0 HUD)
                                                            -- icons are located in materials/hud/lad_framework/styles/
        HeatAuraColor = Color(200, 180, 255, 225),          -- The color of the heat aura around the nextbot
        HeatBarColor = Color(40, 80, 255, 225),           -- The color of the heat bar in the HUD

        NeutralStance = "stand_player_kiryu",               -- Neutral idle stance
        NeutralWalk = "walk_slow",                          -- Neutral walking stance
        NeutralRun = "run_player",                          -- Neutral running stance

        CombatStance = "kiryu_s_stand_lp",                  -- Combat idle stance
        CombatWalk = "kiryu_s_shift",                       -- Combat walk stance
        CombatRun = "kiryu_l_run",                          -- Combat running stance
        CombatGuard = "kiryu_s_guard",                      -- Combat guarding stance, if not specified, guarding is disabled
        CombatSwitch = "kiryu_s_style_st_long",             -- Plays when switched from another moveset to this

        HeatPopAnim = {  -- Animation(s) to play when popping heat, if empty, no animations will play, if more than one, they will be played randomly
            "kiryu_s_provoke_2"
        },

        CombatBattleStart = {   -- Combat activation animations, if empty, no animations will play, if more than one, they will be played randomly
            "kiryu_s_start_warmup",
            "kiryu_s_start_point",
            "kiryu_s_start_fist_crack",
            "kiryu_s_start_turn"
        },

        AnimRate = 1,                   -- Animation playback rate, 1 is normal speed, 0.5 is half speed, etc.
        TauntHeatRate = 20,             -- Heat gain while taunting, 0 to disable heat gain while taunting

        -- Optional properties with default values below, they do not need to be set unless you want to change the default behavior
        CanPickUpWeapons = true,        -- Can the nextbot pick up weapons? If false, it will not pick up any weapons


        WeaponAttachment = "weapon",  -- Attachment to use for weapons, if empty, "weapon" will be used
        PreciseAnimCycle = false,     -- If true, node transitions will be more precise, but may cause issues with some animations
        InputBufferTime = 0.17,       -- Time in seconds to buffer input for moves, default is 0.17 seconds as specified in self.InputBufferTime
        DamageMultiplier = 1,         -- Damage multiplier for attacks, default is 1 (no multiplier)

        -- Very specific use cases, do not change unless you know what you are doing
        -- CombatDrawWeapon = {        -- List of random weapon draw animations for weapon movesets
        --     "p_wep_d_equip",
        -- },
        -- CombatStashWeapon = {       -- List of random weapon stash animations for weapon movesets
        --     "p_wep_d_bat_holster",
        -- },
    },
    ["AIProperties"] = {
        AttackRange = 70,             -- Range in Hammer Units at which AI will attack, default is 70 units
        RangeAttackRange = 250,       -- Range in Hammer Units at which AI will use ranged attacks, default is 250 units
        ReachEnemyRange = 65,         -- Distance at which AI will try to reach the enemy, default is 65 units

        NextAttack = {1, 4},          -- Randomized time in seconds between attacks, default is 1 to 4 seconds
        SwayNextAttack = 1,           -- NextAttack time after swaying

        SwayFrequency = 2,            -- Chance for AI to sway, 1 in x
        StrafeHoriz = {20, 50},       -- Horizontal strafe distance in units, randomized between these values
        StrafeVert = {5, 10},         -- Vertical strafe distance in units, randomized between these values

        TauntRate = 15,                 -- Chance for AI to taunt, 1 in x, default is 15, defined as self.TauntRate in fighter_command.lua

        -- Optional AI properties with default values below, they do not need to be set unless you want to change the default behavior
        WeaponPickUpChance = 30,      -- Chance for AI to pick up a weapon, 1 in x, default is 30
        WeaponSearchRadius = 400,     -- Radius in which AI will search for weapons, default is 400
    },
    ["CustomMovesetInitialize"] = function(self)    -- Optional custom function called when the moveset is set
        local ID = math.random(1,3)
        print("test "..tostring(ID))
    end,
    ["AvailableHacts"] = {      -- List of Heat Actions available for this moveset, located in lua/lad_framework/hact/, each name must match the file name
        "h1500_oi_trample_ao",
        "h1511_oi_kickover_utu_c",
    },
    ["MoveTable"] = {
        ["Root"] = {
            FollowUps = {       -- followup order matters in Root node, otherwise it won't be executed properly
                {
                    FollowsUpTo = "GuardCounter",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        EnemyDistanceLessThan = 70,
                        EnemyAttacking = true,
                        NotDowned = true,
                        Guarding = true,
                        GuardHit = true,
                        Standing = true,
                    },
                },
                {
                    FollowsUpTo = "Seize_HeavyAttack",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        NotDowned = true,
                        Grabbing = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Seize_FacePlant",
                    Conditions = {
                        KeyPress = IN_RELOAD,
                        RequiredPress = 4,  --unimplemented
                        NotFlinching = true,
                        NotDowned = true,
                        Grabbing = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "AttackCounter",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        LockedIn = true,
                        EnemyAttacking = true,
                        EnemyDistanceLessThan = 70,
                        NotFlinching = true,
                        NotDowned = true,
                        Standing = true,
                    },
                },
                {
                    FollowsUpTo = "DownedStomp",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        EnemyDowned = true,
                        EnemyDistanceLessThan = 90,
                        LockedIn = true,
                        NotFlinching = true,
                        NotDowned = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Kick_Heavy",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        NotDowned = true,
                        NotGrabbing = true,
                        LockedIn = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Light_1_Running",        -- light_1_running needs to be above light_1
                    Conditions = {
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        Running = true,
                        NotDowned = true,
                        NotGrabbing = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "RunAttack",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Running = true,
                        NotDowned = true,
                        NotGrabbing = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Seize",
                    Conditions = {
                        KeyPress = IN_RELOAD,
                        NotFlinching = true,
                        NotDowned = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Light_1",
                    Conditions = {
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        NotDowned = true,
                        NotGrabbing = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Heavy_1",
                    Conditions = {
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        NotDowned = true,
                        NotGrabbing = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Provoke",
                    Conditions = {
                        ButtonPress = KEY_F,
                        NotFlinching = true,
                        NotDowned = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Sway",
                    Conditions = {
                        ButtonPress = KEY_E,
                        NotFlinching = true,
                        Standing = true,
                        NotDowned = true,
                        Standing = true,
                    }
                },
            }
        },
        ["Light_1"] = {
            Anim = "kiryu_s_cmb_01",
            FollowUps = {
                {
                    FollowsUpTo = "Light_2",
                    Conditions = {
                        AnimCycle = { 0.27, 0.53 },
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Finisher_1A",
                    Conditions = {
                        AnimCycle = { 0.33, 0.54 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Standing = true,
                    }
                }
            },
            Tags = { Attack = true }
        },
        ["Light_1_Running"] = {
            Anim = "kiryu_s_cmb_01_run",
            FollowUps = {
                {
                    FollowsUpTo = "Light_2",
                    Conditions = {
                        AnimCycle = { 0.36, 0.6 },
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Finisher_1A",
                    Conditions = {
                        AnimCycle = { 0.41, 0.55 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Standing = true,
                    }
                }
            },
            Tags = { Attack = true }
        },
        ["Light_2"] = {
            Anim = "kiryu_s_cmb_02",
            FollowUps = {
                {
                    FollowsUpTo = "Light_3",
                    Conditions = {
                        AnimCycle = { 0.33, 0.55 },
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Finisher_2A",
                    Conditions = {
                        AnimCycle = { 0.35, 0.55 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Standing = true,
                    }
                }
            },
            Tags = { Attack = true }
        },
        ["Light_3"] = {
            Anim = "kiryu_s_cmb_03",
            FollowUps = {
                {
                    FollowsUpTo = "Light_4",
                    Conditions = {
                        AnimCycle = { 0.35, 0.55 },
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        Standing = true,
                    }
                },
                {
                    FollowsUpTo = "Finisher_3A",
                    Conditions = {
                        AnimCycle = { 0.35, 0.55 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Standing = true,
                    }
                }
            },
            Tags = { Attack = true }
        },
        ["Light_4"] = {
            Anim = "kiryu_s_cmb_04",
            FollowUps = {
                {
                    FollowsUpTo = "Finisher_4A",
                    Conditions = {
                        AnimCycle = { 0.36, 0.55 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Standing = true,
                    }
                }
            },
            Tags = { Attack = true }
        },
        -- ["SwayAttack"] = {
        --     Sway = "kiryu_s_cmb_01",
        --     Tags = { Attack = true }
        -- },
        ["Finisher_1A"] = {
            Anim = "kiryu_s_cmb_01_fin",
            Properties = {
                PibTrail = {
                    {
                        AttachmentID = 11, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 5,
                        EndWidth = 0,
                        Lifetime = 0.12,
                        DecayTime = 0.3,
                        Resolution = (1 / ( 5 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
            Tags = { Attack = true }
        },
        ["Finisher_2A"] = {
            Anim = "kiryu_s_cmb_02_fin",
            Properties = {
                PibTrail = {
                    {
                        AttachmentID = 10, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 5,
                        EndWidth = 0,
                        Lifetime = 0.12,
                        DecayTime = 0.3,
                        Resolution = (1 / ( 5 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
            Tags = { Attack = true }
        },
        ["Finisher_3A"] = {
            Anim = "kiryu_s_cmb_03_fin",
            FollowUps = {
                {
                    FollowsUpTo = "Finisher_3A_Sync",
                    Conditions = {
                        ButtonPress = KEY_R,
                        AnimCycle = { 0.38, 0.41 },
                        MustHit = true,
                        EnemyNotGuarding = true,
                        RequiredHeat = 100,
                        Standing = true,
                    }
                }
            },
            Properties = {
                PibTrail = {
                    {
                        AttachmentID = 10, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 5,
                        EndWidth = 0,
                        Lifetime = 0.12,
                        DecayTime = 0.3,
                        Resolution = (1 / ( 5 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
            Tags = { Attack = true }
        },
        ["Finisher_3A_Sync"] = {
            SyncHit = {
                front = {
                    "kiryu_s_cmb_03_fin_sync",
                    "kiryu_s_cmb_03_fin_sync1",
                    SyncAngle = 180   --SyncAngle only affects sync1
                },
                back = {
                    "kiryu_s_cmb_03_fin_sync",
                    "kiryu_s_cmb_03_fin_sync1_b",
                    SyncAngle = 0
                }
            },
            Properties = {
                NoHeatGain = true,  -- unimplemented
                SyncPositioning = 67,
                ConsumesHeat = 200
            }
        },
        ["Finisher_4A"] = {
            Anim = "kiryu_s_cmb_04_fin",
            FollowUps = {
                {
                    FollowsUpTo = "Finisher_4B",
                    Conditions = {
                        AnimCycle = { 0.41, 0.64 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        RequiredHeat = 200,
                        Standing = true,
                    }
                },
            },
            Properties = {
                PibTrail = {
                    {
                        AttachmentID = 10, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 5,
                        EndWidth = 0,
                        Lifetime = 0.4,
                        DecayTime = 0.6,
                        Resolution = (1 / ( 5 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
            Tags = { Attack = true }
        },
        ["Finisher_4B"] = {
            Anim = "kiryu_s_cmb_04_finw",
            Properties = {
                PibTrail = {
                    {
                        AttachmentID = 12, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 10,
                        EndWidth = 0,
                        Lifetime = 0.2,
                        DecayTime = 0.8,
                        Resolution = (1 / ( 20 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
            Tags = { Attack = true }
        },
        ["Heavy_1"] = {
            Anim = "kiryu_s_atk_kick_cmb_01",
            FollowUps = {
                {
                    FollowsUpTo = "Heavy_2",
                    Conditions = {
                        AnimCycle = { 0.33, 0.41 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        RequiredHeat = 100,
                        Standing = true,
                    }
                },
            },
            Properties = {
                PibTrail = {
                    {
                        AttachmentID = 12, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 10,
                        EndWidth = 0,
                        Lifetime = 0.3,
                        DecayTime = 0.3,
                        Resolution = (1 / ( 10 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
            Tags = { Attack = true }
        },
        ["Heavy_2"] = {
            Anim = "kiryu_s_atk_kick_cmb_02",
            FollowUps = {
                {
                    FollowsUpTo = "Heavy_3",
                    Conditions = {
                        AnimCycle = { 0.42, 0.48 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        Standing = true,
                    }
                },
            },
            Tags = { Attack = true },
            Properties = {
                ConsumesHeat = 100,
                PibTrail = {
                    {
                        AttachmentID = 11, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 5,
                        EndWidth = 0,
                        Lifetime = 0.12,
                        DecayTime = 0.6,
                        Resolution = (1 / ( 5 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
        },
        ["Heavy_3"] = {
            Anim = "kiryu_s_atk_kick_cmb_03",
            Tags = { Attack = true },
            Properties = {
                ConsumesHeat = 100,
                PibTrail = {
                    {
                        AttachmentID = 12, -- Use self:LookUpAttachment in here if you don't know IDs.
                        Delay = 0.2,
                        Color = Color(155, 155, 255, 255),
                        Additive = true,
                        StartWidth = 10,
                        EndWidth = 0,
                        Lifetime = 0.4,
                        DecayTime = 0.6,
                        Resolution = (1 / ( 10 )) * 0.5,
                        IMaterial = "trails/plasma"
                    }
                },
            },
        },
        ["Sway"] = {
            Sway = {
                Front = "kiryu_s_sway_front",
                Back = "kiryu_s_sway_back",
                Left = "kiryu_s_sway_left",
                Right = "kiryu_s_sway_right"
            },
            FollowUps = {
                {
                    FollowsUpTo = "Sway_Attack",
                    Conditions = {
                        AnimCycle = { 0.2, 0.48 },
                        KeyPress = IN_ATTACK2,
                        NotFlinching = true,
                        NotDowned = true,
                        Standing = true,
                    }
                },
            },               
            Properties = {
                iFrameCycle = { 0, 0.8 },
                Afterimage = {
                    Interval = 0.1,
                    Repetitions = 1,
                    AfterimageColor = Color(155, 155, 155, 50)
                },
            },
        },
        ["Sway_Attack"] = {
            Sway = {
                Front = "kiryu_s_atk_sway_front",
                Back = "kiryu_s_atk_sway_back",
                Left = "kiryu_s_atk_sway_left",
                Right = "kiryu_s_atk_sway_right"
            },
            Tags = { Attack = true }
        },
        ["DownedStomp"] = {
            Anim = "kiryu_s_atk_down_kick",
            Tags = { Attack = true }
        },
        ["Provoke"] = {
            Anim = "kiryu_s_provoke_2",
            Tags = { Taunt = true }
        },
        ["Kick_Heavy"] = {
            Anim = "kiryu_s_kick_heavy",
            Tags = { Attack = true }
        },
        ["RunAttack"] = {
            Anim = "kiryu_s_atk_kick_run",
            Tags = { Attack = true }
        },
        ["AttackCounter"] = {
            Anim = "kiryu_s_atk_counter",
            Properties = {
                iFrameCycle = { 0, 0.98 },   -- period of complete invulnerability, no attacks can touch you (iframes)
            },
        },
        ["GuardCounter"] = {
            Anim = "kiryu_s_guard_counter",
            Properties = {
                iFrameCycle = { 0, 0.4 },
            },
        },

        --grabbing

        ["Seize"] = {
            Grab = "p_seize_miss",
            Tags = { Attack = true },
            GrabData = {
                LoopAnim = "kiryu_u_loop",

                FrontPrefix = "lapel",
                BackPrefix = "neck",
                FrontOffset = 32,
                BackOffset = 40,

                CanMove = true,             -- can you move while grabbing?

                SwitchDir = {
                    "p_lapel_to_neck",       -- front to back
                    "p_neck_to_lapel",       -- back to front
                    Offset = {18, 40}
                },

                StartAnim = "kiryu_u_start",
                StartAnimOffset = 40,
                WalkAnim = "kiryu_u_walk",

                Resist = {
                    "kiryu_u_off"
                },
            }
        },
        ["Seize_HeavyAttack"] = {
            GrabAttack = "kiryu_u_atk",
            Properties = {
                SyncVictimWallbound = true,
                SyncPositioning = 37,
            },
        },
        ["Seize_FacePlant"] = {
            GrabAttack = "kiryu_u_nage",
            Properties = {
                SyncPositioning = 32,
            },
        },
        ["GrabLight_1"] = {                 -- unimplemented yet
            Anim = "kiryu_s_cmb_01",
            FollowUps = {
                {
                    FollowsUpTo = "GrabLight_2",
                    Conditions = {
                        AnimCycle = { 0.27, 0.53 },
                        KeyPress = IN_ATTACK,
                        NotFlinching = true,
                        Standing = true,
                    }
                },
            },
            Tags = { Attack = true }
        },
    },
    ["AIMoveTable"] = {         -- default moveset behavior for AI
        Attack = {
            {
                Moves = {
                    "Light_1",
                    "Light_2",
                    "Light_3",
                    "Light_4",
                    "Finisher_4A",
                    "Finisher_4B"
                },
                Weight = 10      -- Higher weight for this sequence
            },
            {
                Moves = {
                    "Light_1",
                    "Light_2",
                    "Light_3",
                    "Light_4",
                    "Finisher_4A",
                },
                Weight = 6
            },
            {
                Moves = {
                    "Light_1",
                    "Finisher_1A",
                },
                Weight = 4
            },
            {
                Moves = {
                    "Light_1",
                    "Light_2",
                    "Finisher_2A",
                },
                Weight = 6
            },
            {
                Moves = {
                    "Light_1",
                    "Light_2",
                    "Light_3",
                    "Finisher_3A",
                    "Finisher_3A_Sync"
                },
                Weight = 5
            },
        },
        HeavyAttack = {
            {
                Moves = {
                    "Heavy_1",
                },
                Weight = 7
            },
            {
                Moves = {
                    "Seize",
                },
                Weight = 15
            },
            {
                Moves = {
                    "Heavy_1",
                    "Heavy_2",
                    "Heavy_3",
                },
                Weight = 5
            },
        },
        GrabAttack = {
            {
                Moves = {
                    "Seize_HeavyAttack",
                },
            },
            {
                Moves = {
                    "Seize_FacePlant",
                },
            },
        },
        RunAttack = {
            {
                Moves = {
                    "RunAttack",
                },
                Weight = 10
            },
            {
                Moves = {
                    "Light_1_Running",
                    "Finisher_1A",
                },
                Weight = 5
            },
            {
                Moves = {
                    "Light_1_Running",
                    "Light_2",
                    "Finisher_2A",
                },
                Weight = 4
            },
            {
                Moves = {
                    "Light_1_Running",
                    "Light_2",
                    "Light_3",
                    "Finisher_3A",
                },
                Weight = 4
            },
            {
                Moves = {
                    "Light_1_Running",
                    "Light_2",
                    "Light_3",
                    "Finisher_3A",
                    "Finisher_3A_Sync",
                },
                Weight = 2
            },
            {
                Moves = {
                    "Light_1_Running",
                    "Light_2",
                    "Light_3",
                    "Light_4",
                    "Finisher_4A",
                },
                Weight = 7
            },
            {
                Moves = {
                    "Light_1_Running",
                    "Light_2",
                    "Light_3",
                    "Light_4",
                    "Finisher_4A",
                    "Finisher_4B",
                },
                Weight = 9
            },
        },
        CounterAttack = {
            {
                Moves = {
                    "AttackCounter"
                },
            },
        },
        EnemyDowned = {
            {
                Moves = {
                    "DownedStomp"
                },
            },
        },
        Provoke = {
            {
                Moves = {
                    "Provoke"
                },
            }
        },
        Sway = {
            {
                Moves = {
                    "Sway",
                },
            }
        }
    },
    ["MovesetEvents"] = {
        ["style_trans_brawler"] = {
            func = function(self, key)
                self:CICO(function()
                    self:PlaySequenceAndMove("kiryu_s_to_s",1)
                    --self:SetFighterMoveset(self.SelectedMoveset, true)
                end)
            end,
        },
        ["atk_tigerdrop"] = {       -- is not actually tiger drop
            Attack = {
                Damage = 150,
                HitSounds = "ladsource/y0/battle_common/dod_atk_s1.wav",
                HitSoundLevel = 65,
                ScreenShake = {
                    Amplitude = 12,
                    Frequency = 20,
                    Duration = 0.23
                },
                HitReaction = "dwn_direct_bound",
                CancelsGuard = true,
                Agony = true,
                AgonyChance = 50,  -- chance to trigger agony when downed, unimplemented
            },
        },
        ["atk_krs_light"] = {
            Attack = {
                Damage = 17,
                HitSounds = "ladsource/y0/battle_common/p_e_atk"..math.random(1,4)..".wav",
                ScreenShake = {
                    Amplitude = 10,
                    Frequency = 10,
                    Duration = 0.2
                },
            },
        },
        ["atk_lightkick1"] = {
            Attack = {
                Damage = 20,
                HitSounds = "ladsource/y0/battle_common/p_e_atk"..math.random(1,4)..".wav",
                MissSounds = "ladsource/y0/battle_common/swing_kick"..math.random(1,3)..".wav",
                HitProps = true,
                ScreenShake = {
                    Amplitude = 10,
                    Frequency = 12,
                    Duration = 0.3
                },
                BreaksGuard = true,
            },
        },
        ["atk_lightkick2"] = {
            Attack = {
                Damage = 40,
                HitSounds = "ladsource/y0/battle_common/p_e_atk"..math.random(1,4)..".wav",
                ScreenShake = {
                    Amplitude = 10,
                    Frequency = 12,
                    Duration = 0.2
                },
            },
        },
        ["atk_lightkick3"] = {
            Attack = {
                Damage = 70,
                Range = 25,
                HitSounds = "ladsource/y0/battle_common/p_e_atk"..math.random(1,4)..".wav",
                MissSounds = "ladsource/y0/battle_common/swing_kick"..math.random(1,3)..".wav",
                HitProps = true,
                ScreenShake = {
                    Amplitude = 15,
                    Frequency = 10,
                    Duration = 0.2
                },
                BreaksGuard = true,
                HitReaction = "dwn_light_body",
            },
        },
        ["atk_krs_cmb01_fin"] = {
            Attack = {
                Damage = 60,
                HitSounds = "ladsource/y0/battle_common/brawler/fin01_2.wav",
                HitSoundLevel = 65,
                ScreenShake = true,
                BreaksGuard = true,
                HitReaction = "dwn_light_head",
            },
        },
        ["atk_krs_cmb02_fin"] = {
            Attack = {
                Damage = 60,
                HitSounds = "ladsource/y0/battle_common/dod_atk_s2.wav",    -- temp
                HitSoundLevel = 65,
                ScreenShake = true,
                BreaksGuard = true,
                HitReaction = "dwn_upper_body",
            },
        },
        ["atk_krs_cmb03_fin"] = {
            Attack = {
                Damage = 65,
                Range = 35,
                HitSounds = "ladsource/y0/battle_common/dod_atk_s2.wav",    -- temp
                HitSoundLevel = 65,
                HitDowned = true,
                HitReaction = "dwn_direct",
                ScreenShake = true,
                BreaksGuard = true,
                ForceBreakGuard = true,
            },

            dmgfunc = function(self, victim, dmg)
                if !victim._isDowned then
                    self._BrawlerFHit = true
                    timer.Simple(0.5, function()
                        if IsValid(self) then
                            self._BrawlerFHit = false
                        end
                    end)
                    -- this is perhaps the only reason dmgfunc survived, this is used for
                    -- essence of brawler finisher, needs a new solution, too lazy rn
                end
            end
        },
        ["atk_krs_cmb04_fin"] = {
            Attack = {
                Damage = 65,
                Range = 40,
                HitSounds = "ladsource/y0/battle_common/dod_atk_s2.wav",    -- temp
                HitSoundLevel = 65,
                ScreenShake = true,
                BreaksGuard = true,
                HitReaction = "critical_blow",
                ForceBreakGuard = true,
            },
        },
        ["atk_krs_cmb04_finw"] = {
            Attack = {
                Damage = 70,
                Range = 50,
                HitSounds = "ladsource/y0/battle_common/atk/atk_s_03.wav",
                HitSoundLevel = 65,
                ScreenShake = {
                    Amplitude = 20,
                    Frequency = 12,
                    Duration = 0.2
                },
                HitProps = true,
                HitDowned = true,
                BreaksGuard = true,
                HitReaction = "dwn_light_body",
                ForceBreakGuard = true,
            },
        },
        ["atk_runkick"] = {
            Attack = {
                Damage = 50,
                Range = 42,
                Angle = 270,
                Force = Vector(5000, 0, 0),
                HitSounds = "ladsource/y0/battle_common/p_e_atk"..math.random(1,4)..".wav",
                MissSounds = "ladsource/y0/battle_common/swing_kick"..math.random(1,3)..".wav",
                HitSoundLevel = 65,
                ScreenShake = {
                    Amplitude = 13,
                    Frequency = 10,
                    Duration = 0.2
                },
                HitProps = true,
                BreaksGuard = true,
                HitReaction = "dwn_light_body",
            },
        },
        ["kiryu_s_cmb_03_sync_dmg"] = {
            func = function(self, key)
                self:LAD_DoScreenShake(15, 20, 0.2, 300)
            end,
        },
    },
    ["SyncDamageEvents"] = {
        ["dmg_grab_atk_punch"] = 50,
        ["dmg_grab_atk_kick"] = 70,
        ["dmg_grab_nage"] = 70,
        ["dmg_grab_off_hiza"] = 20,
        ["dmg_grab_press_punch"] = 20,
        ["dmg_grab_press_ground"] = 40,
        ["kiryu_s_cmb_03_sync_dmg"] = 110,
    }
}

return MovesetTable, MovesetName