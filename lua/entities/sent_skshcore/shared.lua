-- Made with Dr. Matt's Base Core v3
ENT.Base 		= "base_core3"
ENT.PrintName		= "Skyrim Shouts Core" -- The name the Core will come up as in the Spawnmenu
ENT.Spawnable		= true -- If true, Anyone can spawn the entity
ENT.AdminSpawnable	= true -- If true, Admins can spawn the entity, Set ENT.Spawnable to false to make the Core Admin only.
ENT.Category		= "Portal 2 Cores"
ENT.Animation		= "sphere_idle_neutral" -- Set's the animation of the core, a list can be found here: http://pastebin.com/SAHyMZ3k
ENT.Delay		= 4 -- Delay in seconds between each sound the core makes (excluding 'special' sounds)
ENT.Dir			= "sksh" -- The name of your sub-folder, must be 4 characters.
/*---------------------------------------------------------
	ENT.Dir: Put your stuff in the following folders:
	
	sound/cores/(ENT.Dir)/
	sound/cores/(ENT.Dir)/special/ -- For use.wav, undo.wav and dmg.wav
	models/cores/(ENT.Dir)/
	materials/models/cores/(ENT.Dir)/
---------------------------------------------------------*/

-- Do not worry about anything below this line unless you're an advanced coder and want to do some special coding work.

if SERVER then AddCSLuaFile() end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
		
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
		
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
		
	return ent
		
end

local LastRandom = 0
local radius = 200 // norton edit this, its the sphere radius around the core which effects shall be applied
local force = 1000 // force at which entities are moved (for unrelenting force and whirlwind sprint)

if SERVER then
	function ENT:Think()
		if not self.Playing and not self.MusicCore then
			local r = math.Round(math.random(1,#self.Sounds))
			if r == self.LastRandom then
				r = math.Round(math.random(1,#self.Sounds))
			end
			self.LastRandom = r
			self.Entity:EmitSound(self.Sounds[r])
			self.Playing = true
			// custom shout code stuff
			if string.find(self.Sounds[r], "unrelentingforce") then
				timer.Simple(1.14,function()
					if IsValid(self) and IsValid(self:GetPhysicsObject()) then
						local a1=self:GetPos()
						local e=ents.FindInSphere(self:GetPos(),radius)
						for k,v in pairs(e) do
							if v:GetClass()=="player" or v:GetClass()=="prop_physics" then
								local a2=v:GetPos()
								local vec=a1-a2
								vec:Normalize()
								vec=vec*-1
								
								if v:GetClass()=="player" then
									v:SetVelocity(v:GetVelocity()+(vec*force))
								elseif v:GetClass()=="prop_physics" then
									v:GetPhysicsObject():AddVelocity(vec*force)
								end
							end
						end
					end
				end)
			elseif string.find(self.Sounds[r], "disarm") then
				timer.Simple(1.02,function()
					if IsValid(self) and IsValid(self:GetPhysicsObject()) then
						local e=ents.FindInSphere(self:GetPos(),radius)
						for k,v in pairs(e) do
							if v:GetClass()=="player" then
								v:StripWeapons()
							end
						end
					end
				end)
			elseif string.find(self.Sounds[r], "firebreath") then
				timer.Simple(0.86,function()
					if IsValid(self) and IsValid(self:GetPhysicsObject()) then 
						local e=ents.FindInSphere(self:GetPos(),radius)
						for k,v in pairs(e) do
							if v:GetClass()=="player" or v:GetClass()=="prop_physics" then
								v:Ignite(10,0)
							end
						end
					end
				end)
			elseif string.find(self.Sounds[r], "whirlwindsprint") then
				timer.Simple(0.65,function()
					if IsValid(self) and IsValid(self:GetPhysicsObject()) then
						local ang=self:GetRight()*-1
						self:GetPhysicsObject():AddVelocity(ang*force)
					end
				end)
			end
			// end custom shout code stuff
			timer.Simple(self.SoundLengths[r] + self.Delay, function()
				self.Playing = false
			end)
		end
		self:NextThink( CurTime() + 0.1 )
		return true
	end
end