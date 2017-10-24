uniform vec3 armadilloPosition;
varying vec4 color;

void main() {
	
	color = vec4(0.01,0.01,0.01, 1.0);

	vec4 pos = modelMatrix * vec4(position,1.);
	vec3 middlePoint = vec3(armadilloPosition.x,armadilloPosition.y,armadilloPosition.z-0.85);
	float dist = distance(pos.xyz,middlePoint.xyz);
	if (dist <= 2.5) {
		float a = 1./(2.5*dist*dist);
		color = vec4(a,a,0.9*a,1.0);
	}

  // Multiply each vertex by the view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * viewMatrix * pos;
}
