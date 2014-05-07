#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform vec2 resolution;
uniform float time;
uniform float alpha;
uniform vec3 color;

uniform float size;
uniform float mod;
uniform float rate;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ); //unused. below is in pixels.
	vec3 dry = texture2D(texture, vertTexCoord.st).xyz * vertColor.xyz;
	vec3 wet;

	if (mod(gl_FragCoord.x + (time * rate * 1000.0), mod) < size) //size is wet-size, mod is dry-size
	{
		wet = color;
	}
	else
	{
		wet = dry;
	}

	gl_FragColor = vec4(wet, alpha);
	
}

//also sin(position * numberbars + time), but modulo allows you to make rarer bars.