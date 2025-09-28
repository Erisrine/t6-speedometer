#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include common_scripts\utility;

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onSpawned();
    }
}

onSpawned()
{
    self waittill( "spawned_player" );
    self endon("game_ended");
    self iprintln("^8[^3Speedometerr^8][^5" + "^8]^7 github.com/Erisrine/t6-speedometer");
    self.minSpeed = 0;
    self.maxSpeed = 400;

    for(;;)
    {
        self waittill("spawned_player");
        self thread speedometer();
    }
}

speedometer()
{
    self endon("disconnect");

    hud = newhudelem();
    hud.sort = 2000;
    hud.alignx = "right";
    hud.aligny = "center";
    hud.horzalign = "right"; 
    hud.vertalign = "center";
    hud.x = 10; 
    hud.y = 300;
    hud.fontscale = 1.8;
    hud.alpha = 1;

    hud.label = &"Speed: ^1";
    
    hud setValue(0);

    for(;;)
    {
        wait 0.05; 
        velocity = self getVelocity();
        speed = int( length(velocity) ); // magnitude of velocity vector
        hud.color = speedometer_color(speed);
        hud setValue(speed);
    }
}

speedometer_color(speed)
{
   speedClamped01 = (speed - self.minSpeed) / (self.maxSpeed - self.minSpeed);

   if(speedClamped01 > 1) speedClamped01 = 1; //Do I actually need to do this?
   if(speedClamped01 < 0) speedClamped01 = 0;

   return (speedClamped01, 1 - speedClamped01, 0);
}
