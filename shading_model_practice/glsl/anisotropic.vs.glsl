uniform vec3 lightDirectionUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightColorUniform;
uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;
uniform float alphaX;
uniform float alphaY;


varying vec3 l;
varying vec3 n;
varying vec3 v;
varying vec3 up;

void main() {
	// Normal vector
	n = normalMatrix*normal;

	// View vector
	v = (modelViewMatrix * vec4(position,1.0)).xyz;

	// Light vector
	vec4 light = viewMatrix*vec4(lightDirectionUniform,0.0);
	l = light.xyz;

	up = viewMatrix * vec3(0.,1.,0.);

	gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}