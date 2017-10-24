varying vec3 light;
uniform vec3 lightPosition;

void main() {
	// Calculate position in world coordinates
	vec4 wpos = modelMatrix * vec4(position, 1.0);

	// Calculates vector from the vertex to the light
	vec3 l = lightPosition - wpos.xyz;

	// Contribution based on cosine
	light = vec3(1.0) * dot(normalize(l), normal);

    // Multiply each vertex by the view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * viewMatrix * wpos;
}
