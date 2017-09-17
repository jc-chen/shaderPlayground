// Create shared variable for the vertex and fragment shaders
varying vec3 interpolatedNormal;
uniform vec3 lightPosition;
uniform vec3 armadilloPosition;
varying vec3 Position;

void main() {
    // Set shared variable to vertex normal
    interpolatedNormal = modelMatrix * normal;

    // Set shared variable to vertex position

    vec3 armadilloPos = vec3(1.5*sin(armadilloPosition.x),0.5*sin(3.*armadilloPosition.y)+0.5,armadilloPosition.z);
   

    Position = modelMatrix * (position+armadilloPos);

    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position+armadilloPos, 1.0);
}
