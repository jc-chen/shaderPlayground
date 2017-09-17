uniform vec3 lightPosition;
uniform vec3 discoBallRotation;
varying vec3 interpolatedNormal;

void main() {
	float cos = dot(interpolatedNormal,interpolatedNormal);
	gl_FragColor = vec4(1.-0.7*cos,1.-0.7*cos,1.-0.6*cos, 1);
}