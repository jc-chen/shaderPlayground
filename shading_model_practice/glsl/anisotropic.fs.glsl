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

	vec3 V = normalize(-v);

	vec3 L = normalize(l);

	vec3 N = normalize(n);

	vec3 H = normalize(L+V);

	vec3 T = normalize(cross(up,N));

	//AMBIENT
	vec3 light_AMB = kAmbientUniform*ambientColorUniform;

	//DIFFUSE
	float A = max(dot(N,L),0.0);
	vec3 light_DFF = kDiffuseUniform*A*lightColorUniform;
	light_DFF = clamp(light_DFF,0.0,1.0);

	//SPECULAR
	float bx = pow(dot(H,T)/alphaX,2.);
	float by = pow(dot(H,T)/alphaY,2.);
	float k = kSpecularUniform*sqrt(dot(L,N)/dot(V,N))*exp(-2.*(bx+by)/(1.+dot(H,N)));
	float B = max(dot(H,N),0.0);
	B = pow(B,shininessUniform);
	vec3 light_SPC = k*B*lightColorUniform;
	light_SPC = clamp(light_SPC,0.0,1.0);

	//TOTAL
	vec3 TOTAL = light_AMB + light_DFF + light_SPC;
	gl_FragColor = vec4(TOTAL, 0.0);

}