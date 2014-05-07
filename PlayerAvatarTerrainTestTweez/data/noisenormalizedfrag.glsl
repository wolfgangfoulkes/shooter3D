#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform float time;
uniform vec2 resolution;
uniform float alpha;
uniform float floor;
uniform float ceil;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec4 dry = texture2D(texture, vertTexCoord.st);// * vertColor;

	float noise = cos(position.x*1000.0+cos(position.y*489.9+time+position.x*50.0)*1450.0);

	float norm = distance(dry.xyz, vec3(0.0));

	if (norm >= ceil) {norm = 1.0;}
	if (norm < floor) {discard;} //{norm = 0.0;}

	gl_FragColor = vec4( vec3( norm ) * vec3( noise ) * vertColor.xyz, alpha);

}