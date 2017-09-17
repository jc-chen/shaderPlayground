// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
varying vec3 interpolatedNormal;
uniform vec3 lightPosition;
uniform vec3 armadilloPosition;
varying vec3 Position;

void main() {
  // Set final rendered color 
  vec3 lightVector = normalize(lightPosition - Position);
  vec3 nor = normalize(interpolatedNormal);
  float cos = dot(lightVector,nor);
  float g = 1.;
  float l = distance(Position, lightPosition);
  if (l<3.5) {g=0.;}

  gl_FragColor = vec4(g*cos,cos,g*cos,1);

  /*
  The idea is that with worldview matrix and all the vs matrix multiplication, you are transforming from world
  coord to screen coord. that is why your light is weird. transform from world to screen coord before
  you try fragment shading
  draw out the 2 worlds n the vectors switching between the 2 to make clear.
  https://piazza.com/class/j72su9hgfvv14w?cid=20
  */

}
