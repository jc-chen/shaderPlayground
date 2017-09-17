varying vec3 interpolatedNormal;
uniform vec3 lightPosition;
uniform vec3 armadilloPosition;
varying vec3 Position;

void main() {
  vec3 lightVector = normalize(lightPosition - Position);
  vec3 nor = normalize(interpolatedNormal);
  float cos = dot(lightVector,nor);
  float g = 1.;
  float l = distance(Position, lightPosition);
  if (l<3.5) {g=0.;}

  gl_FragColor = vec4(g*cos,cos,g*cos,1);

}
