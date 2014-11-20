-- Simple Evelynn v1 --
-- By: Kawaii Nekochan --
if GetMyHero().charName ~= "Evelynn" and not VIP_USER then
return
end

require 'VPrediction'
require 'SourceLib'
require 'AoE_Skillshot_Position'

local Qrange = 700
local Erange = 225
local Rrange, Rradius, Rdelay = 650, 500, 0.25
PrintChat("You are using Simple Evelynn by Kawaii Nekochan.")

function OnLoad()
	VP = VPrediction(true)
	STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
	
	EveMenu = scriptConfig("Simple Evelynn v1", "Evelynn")
	EveMenu:addSubMenu("Target Selector", "STS")
	STS.AddToMenu(EveMenu.STS)
	EveMenu:addSubMenu("Combo", "Combo")
	EveMenu.Combo:addParam("combokey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
	EveMenu.Combo:addParam("ult", "Press R to use Ultimate", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
	EveMenu.Combo:addParam("autoult", "Auto use Ult if 3 or more enemies in range", SCRIPT_PARAM_ONOFF, false)
	EveMenu:addSubMenu("AutoLvl", "Auto Level")
	EveMenu.AutoLvl:addParam("autolvl" , "Auto Level Spells", SCRIPT_PARAM_ONOFF, false)
	EveMenu:addSubMenu("Drawing", "Drawing")
	EvenMenu.Drawing:addParam("DrawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	EvenMenu.Drawing:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	EvenMenu.Drawing:addParam("DrawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	EvenMenu.Drawing:addParam("DrawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
	EveMenu:permaShow("combokey")
	EveMenu:permaShow("autoult")
	EveMenu:permaShow("autolvl")

end

function OnDraw()
	if EveMenu.Drawing.DrawAA then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, 125, 0x00FF00)
	end
	if EveMenu.Drawing.DrawQ then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, Qrange, 0x00FF00)
	end
	if EveMenu.Drawing.DrawE then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, Erange, 0x00FF00)
	end
	if EveMenu.Drawing.DrawR then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, Rrange, 0x00FF00)
	end

end

function OnTick()
	if EveMenu.Combo.combokey then
		_Combo()
	end
	if EveMenu.Combo.ult then
		_Ult()
	end
	if EveMenu.AutoLvl.autolevel then
		_AutoLvl()
	end

end

function _Combo()
	if My.Hero:CanUseSpell(_W) == READY and ValidTarget(target) and GetDistance(target) <= Qrange + 100 then
		CastSpell(_W)
	end
	local target = STS:GetTarget(Qrange)
	if myHero:CanUseSpell(_Q) == READY and ValidTarget(target) and GetDistance(target) <= Qrange then
		CastSpell(_Q)
	end
	local target = STS:GetTarget(Erange)
	if myHero:CanUseSpell(_E) == READY and ValidTarget(target) and GetDistance(target) <= Erange then
		CastSpell(_E)
	end
	local target = STS:GetTarget(Rrange)
	if My.Hero:CanUseSpell(_R) == READY and EveMenu.Combo.autoult and TargetsInUlt(GetAoESpellPrediction(Rradius, target), Rradius) then
		_Ult()
	end
end

function _Ult()
local position = VP:GetPredictedEnemyPos(enemy, Rdelay)
	if myHero:CanUseSpell(_R) == READY and GetDistance(position) <= Rrange then
	CastSpell(_R, position.x, position.z)
	end
end

function _TargetsInUlt(spellPos, Rradius)
	local count = 0
	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and ValidTarget(enemy) and GetDistance(spellPos, enemy) <= Rradius then
		count = count + 1
		end
	end
		if count >=3 then
			return true
		end
end

function _AutoLvl()
	Sequence = {1,3,2,1,1,4,3,1,3,1,4,3,3,2,2,4,2,2}
	autoLevelSetSequence(Sequence)
end
