#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif



varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform vec2 resolution;
uniform float time;
uniform float floor;
uniform float ceil;
uniform float alpha;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

		float color = cos(position.x*1000.0+cos(position.y*489.9+time+position.x*50.0)*1450.0);
		vec3 noise = vec3(color);

		vec4 dry = texture2D(texture, vertTexCoord.st) * vertColor;
		
		vec3 mixed = mix(dry.xyz, vec3(0.0), floor);

		float white = distance(mixed, vec3(0.0, 0.0, 0.0));

		if (white <= floor) //can replace with "floor", so you can set externally.
		{
			discard;
		}
		else if (white >= ceil) //can replace with "ceil"
		{
			gl_FragColor = vec4(noise, alpha);
		}
		else
		{
			//gl_FragColor = dry;
		}

}