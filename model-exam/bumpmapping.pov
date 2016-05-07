#include "colors.inc"
#include "textures.inc"


background { color White }

camera
{
   location <0, 0,-5>
   look_at <0,0,0>
}

light_source
{
    <0, 0, -5> color White
}
                 
sphere
{
    <0,0,0> 1
    texture
    {
        pigment
        {
            color White
        }
        
        normal {
    gradient x       //this is the PATTERN_TYPE
    normal_map {
      [0.3  bumps scale 0.1]
    }
  }
    }
}
