varying vec4 color;

void main() {
	if (color.rgb == vec3(0.0,0.0,0.5))
		discard;

	gl_FragColor = color; 
}
