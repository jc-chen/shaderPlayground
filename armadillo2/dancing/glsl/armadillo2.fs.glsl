varying vec4 color;

void main() {

	if (color.rgb == vec3(0.2,0.0,0.1))
		discard;
		
	gl_FragColor = color; 
}
