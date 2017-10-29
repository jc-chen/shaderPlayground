uniform vec3 lightDirectionUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightColorUniform;

varying vec3 l;
varying vec3 n;
varying vec3 v;

void main() {

	vec3 V = normalize(-v);
	vec3 L = normalize(l);
	vec3 N = normalize(n);

	float lightIntensity = max(dot(N,L),0.0); 

   	vec4 resultingColor = vec4(0.,0.,0.,0.);

   	// Quantize the colours
   	if (lightIntensity > 0.9)
   		resultingColor = vec4(0.813, 0.750, 0.986,1.0);
   	else if (lightIntensity > 0.7)
   		resultingColor = vec4(0.711, 0.633, 0.847,1.0);
   	else if (lightIntensity > 0.5)
   		resultingColor = vec4(0.341, 0.231, 0.647,1.0);
  	else if (lightIntensity > 0.3)
   		resultingColor = vec4(0.3, 0.172, 0.607,1.0);
  	else
   		resultingColor = vec4(00.133, 0.113, 0.184,1.0);

   	// Add black silhouette
    float k = abs(dot(V,N));
    float thickness = 0.2;
    if (k < thickness)
    	resultingColor = vec4(0.,0.,0.,1.);

	gl_FragColor = resultingColor;
}
