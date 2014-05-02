#ifdef GL_ES
precision mediump float;
#endif

//wow

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float alpha;

void main( void ) {

	vec2 position = (cos(time / 5.0) * sin(time / 10.0) + 1.0) * ( gl_FragCoord.xy / resolution.xy * 2.0 - 1.0 ) * vec2(resolution.x / resolution.y, alpha);
	float color = sin(length(position*1000.0));
	gl_FragColor = vec4( vec3(color), alpha );
}