#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec3 color1;
uniform vec3 color2;

uniform float div1;
uniform float div2;
uniform float alpha;
uniform float rate;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 wet;
	
	if (mod(position.x + (time * rate), (1.0/div1)) < (1.0/div1) / div2)
	{
		wet = texture2D(texture, vertTexCoord.st).xyz * color1;
	}	
	else
	{
		discard;
	}

	gl_FragColor = vec4( wet, alpha );

}