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

//color-stuff
uniform vec3 color1;
uniform vec3 color2;
uniform float div1;
uniform float div2;
uniform float rate;

void main( void ) {

	vec3 final;

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec4 dry = texture2D(texture, vertTexCoord.st);// * vertColor;

	float noise = cos(position.x*1000.0+cos(position.y*489.9+time+position.x*50.0)*1450.0);

	//colored bars
	vec3 wet;
	if (mod(position.x + (time * rate), 1.0/div1) < div1/div2) //div1 is wet-size, div2 is dry-size
	{
		wet = color1 * vec3(noise);
	}
	else
	{
		wet = vec3(noise);
	}
	
	float norm = distance(dry.xyz, vec3(0.0));
	
	if (norm < floor) {discard;} //{norm = 0.0;}
	else if (norm >= ceil) {norm = 1.0;}

	gl_FragColor = vec4( vec3( norm ) * wet * vertColor.xyz, alpha);

}