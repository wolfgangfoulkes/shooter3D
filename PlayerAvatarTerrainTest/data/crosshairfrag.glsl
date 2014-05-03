#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform sampler2D texture;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float alpha;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = ( mouse.xy / resolution.xy );

	float d = distance(mouse, p);
	float r = 2.0 * sin(d * 3.14 * 1000.0 - time * 10.0);
	float g = sin(d * 3.14 * 500.0  * mouse.y - time * 40.0);
	float b = sin(d * 3.14 * 2.0 - time * 10.0);
	
	

	gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4( r, g, b, alpha );
}