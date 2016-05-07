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
                 
                 
plane
{
  <0,0,1>, 4
  
  texture
  {
    pigment
    {
      checker Black, White
    }
  }
}                 
                      
#declare Lens = intersection
                {
                  sphere
                  {
                    <0,0,1.5> 2
                  }            
                  sphere
                  {
                    <0,0,-1.5> 2
                  }             
                  texture
                  {
                    pigment { color rgbt <0,0,0.5,0.5> }
                  }                                     
                  interior { ior 2 }
                }
                
                
object
{     
  Lens
  rotate <0,90,0>
  translate <-3,0,0>
}

object
{     
  Lens
}     

object
{     
  Lens
  translate <3,0,0>   
  rotate <90,0,0>
}