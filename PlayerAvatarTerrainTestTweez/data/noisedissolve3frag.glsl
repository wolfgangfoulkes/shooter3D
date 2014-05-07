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

uniform vec3 color;

uniform float size;
uniform float mod;
uniform float rate;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec4 dry = texture2D(texture, vertTexCoord.st) * vertColor;
		
	vec3 mixed = mix(dry.xyz, vec3(0.0), floor);

	vec3 wet;

	//noise
	float noise = cos(position.x*1000.0+cos(position.y*489.9+time+position.x*50.0)*1450.0);

	//colored bars. replace with sine later probably and just multiply by the noise later.
	if (mod(position.x + (time * rate), mod) < size) //size is wet-size, mod is dry-size
	{
		wet = color * vec3(noise);
	}
	else
	{
		wet = vec3(noise);
	}

	float white = distance(mixed, vec3(0.0, 0.0, 0.0));

	if (white <= floor) //can replace with "floor", so you can set externally.
	{
		discard;
	}
	else if (white >= ceil) //can replace with "ceil"
	{
		gl_FragColor = vec4(wet, alpha);
	}

}