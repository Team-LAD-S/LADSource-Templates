if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "lad_framework_base"

-- Misc --
ENT.PrintName = "Metropolice"
ENT.Category = "Like a Dragon: Extras"
ENT.Models = {"models/ladsource/c_cm_police.mdl"}       
ENT.Factions = {FACTION_COMBINE}

ENT.FighterMoveset = "E_ZAKO"
ENT.FighterVoicebank = "metropolice"
ENT.FighterName = "#ladfighter.hl2.police"

ENT.SpawnHealth = 120

ENT.WeaponTech = "P"
ENT.HeatGears = 2

AddCSLuaFile()
DrGBase.AddNextbot(ENT)