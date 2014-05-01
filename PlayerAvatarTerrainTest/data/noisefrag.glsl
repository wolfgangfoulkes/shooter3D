#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform vec2 resolution;
uniform float time;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 
	cos(position.x * 1000.0 + cos(position.y * 4.9 + time + position.x * 50.0) * 1450.0);
	gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4( vec3(color), 0.5 );

}