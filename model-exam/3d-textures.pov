#include "colors.inc"
#include "textures.inc"


background { color White }

camera
{
   location <0, 0,-8>
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
            checker color White, color Black
            scale 0.5
        }
    }
}

sphere
{
    <-3,0,0> 1
     texture { pigment { White_Marble }
               // normal { bumps 0.5 scale 0.05}
               finish { phong 1 } 
               scale 0.5 
             } // end of texture 
}


sphere
{
    <3,0,0> 1
     texture{ pigment{ color rgb< 1, 0.80, 0.55>*0.8}
          normal { pigment_pattern{ crackle turbulence 0.2
                                    colour_map {[0.00, rgb 0]
                                                [0.25, rgb 1]
                                                [0.95, rgb 1]
                                                [1.00, rgb 0]}
                                    scale 0.15} 1}

           finish  { phong 1 reflection 0.05 }
         }
}