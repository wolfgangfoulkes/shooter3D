#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif



varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform vec2 resolution;
uniform float time;
uniform float opacity;
uniform float floor;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

		float color = cos(position.x*1000.0+cos(position.y*489.9+time+position.x*50.0)*1450.0);
		vec4 dry = texture2D(texture, vertTexCoord.st) * vertColor;
		vec3 clamped = clamp(dry.xyz, vec3(1.0 - opacity, 1.0 - opacity, 1.0 - opacity), vec3(opacity, opacity, opacity))
		gl_FragColor = vec4(clamped, 1.0);
		float floor1 = floor;

}