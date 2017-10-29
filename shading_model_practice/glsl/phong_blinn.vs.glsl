uniform vec3 lightDirectionUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightColorUniform;
uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;

varying vec3 l;
varying vec3 n;
varying vec3 v;

void main() {
	// Normal vector
	n = normalMatrix*normal;

	// View vector
	v = (modelViewMatrix * vec4(position,1.0)).xyz;

	// Light vector
	vec4 light = viewMatrix*vec4(lightDirectionUniform,0.0);
	l = light.xyz;

	gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}