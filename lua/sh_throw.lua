/*-------------------------------------------------------------------------------------------------------------------------
	Throw a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Throw"
PLUGIN.Description = "Throw a player."
PLUGIN.Author = "Dr. Matt"
PLUGIN.ChatCommand = "throw"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Throw" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Throw" ) ) then
		local players = evolve:FindPlayer( args, ply )
		
		for _, pl in ipairs( players ) do
			if pl:InVehicle() then pl:ExitVehicle() end
			pl:SetMoveType( MOVETYPE_WALK )
			pl:SetVelocity( Vector( math.random(-4000,4000), math.random(-4000,4000), 4000 ) )
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has thrown ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "throw", unpack( players ) )
	else
		return "Throw", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )