varying vec3 color;
uniform float headRotation;

void main() {
	// Color for the armadillo
	vec3 l = vec3(0.0, 0.0, -1.0);
	color = vec3(1.0) * dot(l, normal);

	vec3 finalPosition = position;

	// Identifying the head
	if (position.z < -0.33 && abs(position.x) < 0.46) {
		color = vec3(1.0, 0.0, 1.0);
		// Rotate the head
		mat3 rotation = mat3(1.,0.,0.,
                            0.,cos(headRotation),-sin(headRotation),
                            0.,sin(headRotation),cos(headRotation));
		finalPosition = vec3(0.0,2.46,-0.33) + rotation * (position - vec3(0.0,2.46,-0.33));
	}

	// Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
	gl_Position = projectionMatrix * modelViewMatrix * vec4(finalPosition, 1.0);
}
