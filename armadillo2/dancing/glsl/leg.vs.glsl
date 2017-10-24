uniform vec3 lightPosition;
uniform vec3 armadilloPosition;
uniform float rightLegAngle;
uniform float leftLegAngle;
varying vec4 color;

void main() {
	color = vec4(0.0, 0.0, 0.5, 0.0);

	vec4 pos = vec4(position,1.0);

	// Identifying the right thigh
	float dist = distance(position,vec3(0.0,1.7,0.0));
	if (dist > 0.36 && position.y < 1.45 && position.x > 0.1) {
		vec3 l = vec3(0.0, 0.0, -1.0);
		color = vec4(vec3(1.0) * dot(l, normal),1.0);
		float theta = rightLegAngle;
		mat4 rotation = mat4(1.0,0.0,0.0,0.0,
							 0.0,cos(theta),-sin(theta),0.0,
							 0.0,sin(theta),cos(theta),0.0,
							 0.0,0.0,0.0,1.0);
		pos = rotation * (vec4(position,1.0) - vec4(0.0,1.75,0.0,1.0)) + vec4(0.0,1.75,0.0,1.0);		
		if (pos.y > 0.23) {
			color = vec4(0.0,0.0,0.3,1.0);
		}
	}

	// Identifying the left thigh
	if (dist > 0.36 && position.y < 1.45 && position.x < -0.15) {
		vec3 l = vec3(0.0, 0.0, -1.0);
		color = vec4(vec3(1.0) * dot(l, normal),1.0);
		mat4 rotation = mat4(1.0,0.0,0.0,0.0,
							 0.0,cos(leftLegAngle),-sin(leftLegAngle),0.0,
							 0.0,sin(leftLegAngle),cos(leftLegAngle),0.0,
							 0.0,0.0,0.0,1.0);
		pos = rotation * (vec4(position,1.0) - vec4(0.0,1.75,0.0,1.0)) + vec4(0.0,1.75,0.0,1.0);
		if (pos.y > 0.23) {
			color = vec4(0.0,0.0,0.3,1.0);
		}	
	}
	// flatten legs
	mat4 thinning = mat4(1.0,0.0,0.0,0.0,
						 0.0,1.0,0.0,0.0,
						 0.0,0.0,0.75,0.0,
						 0.0,0.0,0.0,1.0);

	// Calculate position in world coordinates
	vec4 wpos = modelMatrix * thinning * pos + vec4(armadilloPosition,0.0);

  // Multiply each vertex by the view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * viewMatrix * wpos;
}
