#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float alpha;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.6;
	color += sin( position.x * cos( time / 10.0 ) * 9800.0 ) + cos( position.y * 		cos( time / 1500.0 ) * 10.0 );
	
	color *= cos( time / 100.0 ) * 0.5;
	
	float r = color + color + color * 9.0;
	float g = color * 0.5;
	float b = tan( color + time / 9.0 ) * 0.75;

	vec3 wet = vec3(r, g, b);

	if (distance(wet, vec3(0.0)) < .3) { discard; }

	gl_FragColor = vec4(wet, alpha);

}