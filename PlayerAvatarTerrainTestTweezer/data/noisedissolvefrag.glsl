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
		vec4 wet = vec4( vec3(color), 1.0);
		vec4 mixed = mix(dry, wet, 1.0 - opacity);
		float distance = distance(mixed.xyz, wet.xyz);
		if (distance < floor)
		{
			discard;
		}
		gl_FragColor = mixed;
		//should use mix to mix between the initial and the final texture.
		//if finalcolor.opacity < floor, discard. should work because we're multiplying by color.

}