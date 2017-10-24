uniform vec3 lightPosition;
uniform vec3 eyePosition;

void main() {
  // define some initial rotations to orient the laser
  float xrot = 3.141/2.;
  float zrot = -3.141/2.;
  mat4 initialRotation =  mat4(cos(zrot),-sin(zrot),0,0,
                               sin(zrot),cos(zrot),0,0,
                               0,0,1.,0,
                               0,0,0,1.) * mat4(1.,0.,0.,0.,
                                                0.,cos(xrot),-sin(xrot),0.,
                                                0.,sin(xrot),cos(xrot),0.,
                                                0.,0.,0.,1.);

  // rotating laser WRT lightbulb position
  vec3 eyeVector = vec3(0.,0.,-1.);
  vec3 lightVector = vec3(lightPosition-eyePosition);
  float lightDirection = lightPosition.x/abs(lightPosition.x);

  // theta is the angle to rotate the laser
  float theta = acos(dot(eyeVector,normalize(lightVector))) * lightDirection;
  mat4 trackingRotation = mat4(cos(theta),0,sin(theta),0,0,1.,0,0,-sin(theta),0,cos(theta),0,0,0,0,1.);
  
  // scale the laser so it always hits the lightbulb
  float s = distance(lightPosition,eyePosition)/2.;
  mat4 scalingMatrix = mat4(1.,0,0,0,
                            0,s,0,0,
                            0,0,1.,0,
                            0,0,0,1.);

  // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * viewMatrix * (modelMatrix * trackingRotation * initialRotation * scalingMatrix * vec4(position, 1.0) + vec4(eyePosition,0.));
}

