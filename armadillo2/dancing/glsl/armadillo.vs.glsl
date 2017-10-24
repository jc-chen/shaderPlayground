uniform vec3 lightPosition;
uniform vec3 armadilloPosition;
varying vec4 color;

void main() {

	vec3 l = vec3(0.0, 0.0, -2.0);
	vec3 l2 = vec3(0.0, 2.0, 0.5);
	vec3 l3 = vec3(0.0,0.75,2.0);

	color = vec4(vec3(0.8) * dot(l, normal),1.0) + vec4(vec3(0.35) * dot(l2,normal),0.0)+vec4(vec3(0.35) * dot(l3,normal),0.0);

	vec4 pos = vec4(position,1.0);
	// Identifying the right thigh
	float dist = distance(position,vec3(0.0,1.7,0.0));

	if (dist > 0.36 && position.y < 1.45 && position.x > 0.1) {
		color = vec4(0.0, 0.0, 0.5,0.0);
		// flatten armadillo
		mat4 thinning = mat4(1.0,0.0,0.0,0.0,
							   0.0,1.0,0.0,0.0,
							   0.0,0.0,0.75,0.0,
							   0.0,0.0,0.0,1.0);
		pos = thinning * pos;
	}
	// Identifying the left thigh
	else if (dist > 0.36 && position.y < 1.45 && position.x < -0.15) {
		color = vec4(0.0, 0.0, 0.5, 0.0);
		// flatten armadillo
		mat4 thinning = mat4(1.0,0.0,0.0,0.0,
							   0.0,1.0,0.0,0.0,
							   0.0,0.0,0.75,0.0,
							   0.0,0.0,0.0,1.0);
		pos = thinning * pos;
	}
	// Identifying the head
	else if (position.z < -0.33 && abs(position.x) < 0.46) {
		//color = vec3(1.0, 0.0, 1.0);
		// Scale the head to shorten
		mat4 scaling = mat4(1.0,0.0,0.0,0.0,
							0.0,1.0,0.0,0.0,
							0.0,0.0,0.5,0.0,
							0.0,0.0,0.0,1.0);
		pos = scaling * pos + vec4(0.0,0.0,-0.5*0.3,0.0);

	}
	// Identifying the right arm
	else if (position.x > 0.55 && position.y > 1.9) {
		//color = vec4(0.0,1.0,0.0,0.0);
		float theta = 3.141/2.5;
		float t = -3.141/3.;
		mat4 rotation = mat4(cos(t),0.,sin(t),0.,
                             0.,1.,0.,0.,
                          	 -sin(t),0.,cos(t),0.,
               				 0.,0.,0.,1.) * mat4(1.,0.,0.,0.,
                            					 0.,cos(theta),-sin(theta),0.,
                            					 0.,sin(theta),cos(theta),0.,
                            					 0.,0.,0.,1.);
		vec4 temp = vec4(0.55,2.2,0.11,0.0);
		pos = rotation * (pos - temp) + temp;
		mat4 armScaling = mat4(1.0,0.0,0.0,0.0,
							   0.0,1.0,0.0,0.0,
							   0.0,0.0,1.75,0.0,
							   0.0,0.0,0.0,1.0);
		pos = armScaling * pos;
	}

	// Identifying the left arm
	else if (position.x < -0.6 && position.y > 1.9) {
		//color = vec4(0.0,1.0,0.0,0.0);
		mat4 armScaling = mat4(1.5,0.0,0.0,0.0,
							   0.0,0.95,0.0,0.0,
							   0.0,0.0,1.0,0.0,
							   0.0,0.0,0.0,1.0);
		pos = armScaling * pos + vec4(0.6*0.5,2.1*0.05,0.0,0.0);		
	}
	// Add some color to pants
	else if (pos.y < 1.6 && pos.z > -0.3) {
		// flatten armadillo
		mat4 thinning = mat4(1.0,0.0,0.0,0.0,
							   0.0,1.0,0.0,0.0,
							   0.0,0.0,0.75,0.0,
							   0.0,0.0,0.0,1.0);
		pos = thinning * pos;
		color = vec4(0.0,0.0,0.2,1.0);
	}
	else {
		// flatten armadillo
		mat4 thinning = mat4(1.0,0.0,0.0,0.0,
							   0.0,1.0,0.0,0.0,
							   0.0,0.0,0.75,0.0,
							   0.0,0.0,0.0,1.0);
		pos = thinning * pos;
	}

	// Calculate position in world coordinates
	vec4 wpos = modelMatrix * pos + vec4(armadilloPosition,0.0);

	// Brighten the armadillo
	//if (color.r<0.2 && color.g<0.2 && color.b<0.2)
		//color = vec4(0.2,0.2,0.2,1.0);  

	// Multiply each vertex by the view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * viewMatrix * wpos;
}
