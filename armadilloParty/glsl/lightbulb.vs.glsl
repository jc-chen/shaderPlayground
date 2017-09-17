uniform vec3 lightPosition;

void main() {
    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position+lightPosition, 1.0);
}
