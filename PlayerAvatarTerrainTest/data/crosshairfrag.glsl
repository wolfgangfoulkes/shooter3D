#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform sampler2D texture;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float opacity;

uniform float ir;
uniform float ig;
uniform float ib;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = ( mouse.xy / resolution.xy );

	float d = distance(m, p);
	float r = 2.0 * sin(d * 3.14 * 1000.0 - time * 40.0) * ir;
	float g = sin(d * 3.14 * 300.0  * mouse.y - time * 40.0) * ig;
	float b = sin(d * 3.14 * 2.0 - time * 10.0) * ib;
	vec3 dry = texture2D(texture, vertTexCoord.st).xyz * vertColor.xyz;
	vec3 wet = mix(vec3(r, r, b), vec3(1.0), 1.0 - opacity);

	gl_FragColor = vec4(dry * wet, 1.0);
}