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

	vec3 V = normalize(-v);

	vec3 L = normalize(l);

	vec3 N = normalize(n);

	//AMBIENT
	vec3 light_AMB = kAmbientUniform*ambientColorUniform;

	//DIFFUSE
	float A = max(dot(N,L),0.0);
	vec3 light_DFF = kDiffuseUniform*A*lightColorUniform;
	light_DFF = clamp(light_DFF,0.0,1.0);

	//SPECULAR
	vec3 R = normalize(2.*dot(N,L)*N-L); // Reflection vector
	float B = max(dot(R,V),0.0);
	B = pow(B,shininessUniform);
	vec3 light_SPC = kSpecularUniform*B*lightColorUniform;
	light_SPC = clamp(light_SPC,0.0,1.0);

	//TOTAL
	vec3 TOTAL = light_AMB + light_DFF + light_SPC;
	gl_FragColor = vec4(TOTAL, 0.0);
	
}