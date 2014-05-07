varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform sampler2D texture;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float mix;
uniform float circles;
uniform float pulse;

uniform float border;
uniform float circle_radius;

void main(void)
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = ( mouse.xy / resolution.xy );

	float d = distance(m, p);

	//color junk
	float r = sin(d * 3.14 * circles - (time * 40.0) );
	float b = sin(d * 3.14 * 2.0 - time * 10.0 );
	
	vec3 dry = texture2D(texture, vertTexCoord.st).xyz * vertColor.xyz;
	vec3 wet = vec3(r, 0.0, 0.0);

	//redundant
	vec2 uv = vertTexCoord.st;
	uv -= m;
	float dist = sqrt(dot(uv, uv)); 
	//square root of (s * s + t * t) //same as d. 
	//think it's a way of getting a vector magnitude
	
	//circle. remove "border" and second check to get filled circle.
	vec4 filter;
	if (( dist > circle_radius ) || ( dist < (circle_radius - border) ) || r < .5)
	{
		filter = vec4(dry, 1.0); //* vec4(b, 1.0, 1.0, 1.0);
	}
	else 
	{
		filter = vec4(wet, 1.0);
	}

	gl_FragColor = mix(vec4(dry, r), filter, mix);
	
}