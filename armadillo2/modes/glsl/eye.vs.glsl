varying vec3 color;
uniform vec3 lightPosition;
uniform vec3 eyePosition;
#define MAX_EYE_DEPTH 0.15

void main() {
  // simple way to color the pupil where there is a concavity in the sphere
  // position is in local space, assuming radius 1
  float d = min(1.0 - length(position), MAX_EYE_DEPTH);
  color = mix(vec3(1.0), vec3(0.0), d * 1.0 / MAX_EYE_DEPTH);

  // define some initial rotations to orient the eyeball
  float xrot = 3.141/2.;
  float zrot = -3.141/2.;
  mat4 initialRotation =  mat4(cos(zrot),-sin(zrot),0,0,
                               sin(zrot),cos(zrot),0,0,
                               0,0,1.,0,
                               0,0,0,1.) * mat4(1.,0.,0.,0.,
                                                0.,cos(xrot),-sin(xrot),0.,
                                                0.,sin(xrot),cos(xrot),0.,
                                                0.,0.,0.,1.);

  // rotating eyeball WRT lightbulb position
  vec3 eyeVector = vec3(0.,0.,-1.);
  vec3 lightVector = vec3(lightPosition-eyePosition);
  float lightDirection = lightPosition.x/abs(lightPosition.x);

  // theta is the angle to rotate the eyes
  float theta = acos(dot(eyeVector,normalize(lightVector))) * lightDirection;
  mat4 trackingRotation = mat4(cos(theta),0,sin(theta),0,
                               0,1.,0,0,
                               -sin(theta),0,cos(theta),0,
                               0,0,0,1.);
  
  // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * viewMatrix * (modelMatrix * trackingRotation * initialRotation * vec4(0.07*position, 1.0) + vec4(eyePosition,0.));
}
