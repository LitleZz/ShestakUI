﻿local T, C, L = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	LitePanels configuration file
--	BACKUP YOUR CHANGES TO THIS FILE BEFORE UPDATING!
----------------------------------------------------------------------------------------
lpanels:CreateLayout("Load For All", {

-- Player panel
{	name = "PlayerBottomBlackBar", parent = "oUF_Player",
	anchor_to = "BOTTOMLEFT", x_off = -6, y_off = -7,
	width = 230, height = 3,
	bg_color = "0 0 0", bg_alpha = 1,
},
{	name = "PlayerBottomColorBar", parent = "PlayerBottomBlackBar",
	anchor_to = "CENTER",
	width = 228, height = 1,
	bg_color = "CLASS", bg_alpha = 1,
},
{	name = "PlayerLeftBlackBar", parent = "oUF_Player",
	anchor_to = "BOTTOMLEFT", x_off = -7, y_off = -42,
	width = 3, height = 100,
	bg_color = "0 0 0", bg_alpha = 1,
},
{	name = "PlayerLeftColorBar", parent = "PlayerLeftBlackBar",
	anchor_to = "CENTER",
	width = 1, height = 98,
	bg_color = "CLASS", bg_alpha = 1,
},

-- Target panel
{	name = "TargetBottomBlackBar", parent = "oUF_Target",
	anchor_to = "BOTTOMRIGHT", x_off = 6, y_off = -7,
	width = 230, height = 3,
	bg_color = "0 0 0", bg_alpha = 1,
},
{	name = "TargetBottomColorBar", parent = "TargetBottomBlackBar",
	anchor_to = "CENTER",
	width = 228, height = 1,
	OnLoad = function(self)
		self:RegisterEvent'PLAYER_TARGET_CHANGED'
	end,
	OnEvent = function(self)
		local _, class = UnitClass'target'
		local color = RAID_CLASS_COLORS[class]
		if color then
			self.bg:SetTexture(color.r, color.g, color.b)
		else
			self.bg:SetTexture(unpack(C.media.border_color))
		end
	end,
},
{	name = "TargetRightBlackBar", parent = "oUF_Target",
	anchor_to = "BOTTOMRIGHT", x_off = 7, y_off = -42,
	width = 3, height = 100,
	bg_color = "0 0 0", bg_alpha = 1,
},
{	name = "TargetRightColorBar", parent = "TargetRightBlackBar",
	anchor_to = "CENTER",
	width = 1, height = 98,
	OnLoad = function(self)
		self:RegisterEvent'PLAYER_TARGET_CHANGED'
	end,
	OnEvent = function(self)
		local _,class = UnitClass'target'
		local color = RAID_CLASS_COLORS[class]
		if color then
			self.bg:SetTexture(color.r, color.g, color.b)
		else
			self.bg:SetTexture(unpack(C.media.border_color))
		end
	end,
},

-- Target portrait border
{	name = "TargetPortraitBlackBar", parent = "oUF_Target_PortraitOverlay",
	anchor_to = "TOPLEFT", x_off = -1, y_off = 1,
	width = C.unitframe.portrait_width + 6, height = C.unitframe.portrait_height + 6,
	bg_color = "0 0 0", bg_alpha = 1,
},
{	name = "TargetPortraitColorBar", parent = "TargetPortraitBlackBar",
	anchor_to = "CENTER",
	width = C.unitframe.portrait_width + 4, height = C.unitframe.portrait_height + 4,
	OnLoad = function(self)
		self:RegisterEvent'PLAYER_TARGET_CHANGED'
	end,
	OnEvent = function(self)
		local _,class = UnitClass'target'
		local color = RAID_CLASS_COLORS[class]
		if color then
			if C.unitframe.portrait_classcolor_border then
				self.bg:SetTexture(color.r, color.g, color.b)
			else
				self.bg:SetTexture(unpack(C.media.border_color))
			end
		else
			self.bg:SetTexture(unpack(C.media.border_color))
		end
	end,
},
{	name = "TargetPortraitBlack", parent = "TargetPortraitColorBar",
	anchor_to = "CENTER",
	width = C.unitframe.portrait_width + 2, height = C.unitframe.portrait_height + 2,
	bg_color = "0 0 0", bg_alpha = 1,
},

-- AFK panel
{	name = "AFK", anchor_to = "TOP", y_off = -210,
	width = 180, height = 75,
	text = {
			{	string = L_PANELS_AFK, anchor_to = "TOP", y_off = -10,
				shadow = 0, outline = 3, font = C.font.stats_font, size = C.font.stats_font_size,
			},
			{	string = function()
					if afk_timer then
						local secs = mod(time() - afk_timer, 60)
						local mins = floor((time() - afk_timer) / 60)
					return format("%s:%02.f", mins, secs)
					end
				end, update = 0.1,
				shadow = 0, outline = 3, font = C.font.stats_font, size = C.font.stats_font_size*2,
				anchor_to = "CENTER", color = "1 0.1 0.1"
			},
			{	string = L_PANELS_AFK_RCLICK, anchor_to = "BOTTOM", y_off = 12,
				shadow = 0, outline = 3, font = C.font.stats_font, size = C.font.stats_font_size, 
			},
			{	string = L_PANELS_AFK_LCLICK, anchor_to = "BOTTOM", y_off = 3,
				shadow = 0, outline = 3, font = C.font.stats_font, size = C.font.stats_font_size, 
			}
		},
		OnLoad = function(self)
			self:RegisterEvent("PLAYER_FLAGS_CHANGED")
			self:SetTemplate("Transparent")
			self:Hide()
		end,
		OnEvent = function(self)
			if UnitIsAFK("player") and not afk_timer then
				self.text2:SetText("0:00")
				afk_timer = time()
				self:Show()
			elseif not UnitIsAFK("player") then
				self:Hide()
				afk_timer = nil
			end
		end,
		OnClick = function(self, b)
			self:Hide()
			if b == "LeftButton" then SendChatMessage("", "AFK") end
		end,
		OnEnter = function(self) self:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b) end,
		OnLeave = function(self) self:SetBackdropBorderColor(unpack(C.media.border_color)) end
	},
})

lpanels:CreateLayout("Enable top panel", {

-- Top panel
{	name = "StatContainer",
	anchor_to = "TOP",
	x_off = 0, y_off = -5,
	width = C.toppanel.width, height = C.toppanel.height,
	bg_alpha = 0,
	OnLoad = function(self) if C.toppanel.mouseover == true then self:SetAlpha(0) end  end,
	OnEnter = function(self) if C.toppanel.mouseover == true and not InCombatLockdown() then self:SetAlpha(1) end end,
	OnLeave = function(self)
		--if not strmatch(GetMouseFocus():GetName(),"^LP_") and C.toppanel.mouseover == true then
		if not (GetMouseFocus():GetName():match"^LP_") and C.toppanel.mouseover == true then
			self:SetAlpha(0)
		end
	end,
},
{	name = "BoxL", parent = "StatContainer",
	anchor_to = "LEFT",
	width = "50%", height = "55%",
	gradient = "H",
	bg_color = "CLASS", gradient_color = "CLASS",
	bg_alpha = 0, gradient_alpha = 0.2,
},	
{	name = "BoxR", parent = "StatContainer",
	anchor_to = "RIGHT",
	width = "50%", height = "55%",
	gradient = "H",
	bg_color = "CLASS", gradient_color = "CLASS",
	bg_alpha = 0.2, gradient_alpha = 0,
},
{	name = "LineTBTL",
	parent = "BoxL", anchor_to = "TOP", x_off = 0, y_off = 1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0, gradient_alpha = 0.8,
},
{	name = "LineBBTL",
	parent = "BoxL", anchor_to = "TOP", x_off = 0, y_off = -1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0, gradient_alpha = 0.8,
},
{	name = "LineTL",
	parent = "BoxL", anchor_to = "TOP",
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "CLASS", gradient_color = "CLASS",
	bg_alpha = 0, gradient_alpha = 0.8,
},
{	name = "LineTBTR",
	parent = "BoxR", anchor_to = "TOP", x_off = 0, y_off = 1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0.8, gradient_alpha = 0,
},
{	name = "LineBBTR",
	parent = "BoxR", anchor_to = "TOP", x_off = 0, y_off = -1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0.8, gradient_alpha = 0,
},
{	name = "LineTR",
	parent = "BoxR", anchor_to = "TOP",
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "CLASS", gradient_color = "CLASS",
	bg_alpha = 0.8, gradient_alpha = 0,
},
{	name = "LineTBBL",
	parent = "BoxL", anchor_to = "BOTTOM", x_off = 0, y_off = 1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0, gradient_alpha = 0.8,
},
{	name = "LineBBBL",
	parent = "BoxL", anchor_to = "BOTTOM", x_off = 0, y_off = -1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0, gradient_alpha = 0.8,
},
{	name = "LineBL",
	parent = "BoxL", anchor_to = "BOTTOM",
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "CLASS", gradient_color = "CLASS",
	bg_alpha = 0, gradient_alpha = 0.8,
},
{	name = "LineTBBR",
	parent = "BoxR", anchor_to = "BOTTOM", x_off = 0, y_off = 1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0.8, gradient_alpha = 0,
},
{	name = "LineBBBR",
	parent = "BoxR", anchor_to = "BOTTOM", x_off = 0, y_off = -1,
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "0 0 0", gradient_color = "0 0 0",
	bg_alpha = 0.8, gradient_alpha = 0,
},
{	name = "LineBR",
	parent = "BoxR", anchor_to = "BOTTOM",
	width = "100%", height = 1,
	gradient = "H",
	bg_color = "CLASS", gradient_color = "CLASS",
	bg_alpha = 0.8, gradient_alpha = 0,
}
})

lpanels:ApplyLayout(nil, "Load For All")

if C.toppanel.enable then
	lpanels:ApplyLayout(nil, "Enable top panel")
end