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
uniform float ceil;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

		float color = cos(position.x*1000.0+cos(position.y*489.9+time+position.x*50.0)*1450.0);
		vec4 dry = texture2D(texture, vertTexCoord.st) * vertColor;
		vec4 noise = vec4(vec3(color), opacity);
		float white = distance(dry.xyz, vec3(0.0, 0.0, 0.0));
		if (white <= (1.0 - (opacity * opacity))) //can replace with "floor", so you can set externally.
		{
			discard;
		}
		else if (white >= opacity) //can replace with "ceil"
		{
			gl_FragColor = noise;
		}
		else
		{
			//gl_FragColor = dry;
		}

}