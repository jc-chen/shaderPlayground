uniform vec3 lightPosition;
uniform vec3 discoBallRotation;
varying vec3 interpolatedNormal;

void main() {
	interpolatedNormal =  normal;
    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    float c = cos(discoBallRotation.x);
    float s = sin(discoBallRotation.x);
    vec3 rotation = vec3(c*position.x+s*position.z,position.y,-s*position.x+c*position.z);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(rotation, 1.0);

    /*

    */
}
