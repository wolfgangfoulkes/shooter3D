varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform sampler2D texture;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float alpha;

uniform float floor;
uniform float ceil;

uniform float mix;
uniform float periods;
uniform float rate;

uniform float border;
uniform float circle_radius;

uniform vec3 color;

void main(void)
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = ( mouse.xy / resolution.xy );

	float d = distance(m, p);

	//color junk
	float r = sin(d * 3.14 * (periods/circle_radius * 2.0) - (time * rate) );
	float di = cos(d * 3.14 * (periods/circle_radius * 2.0) - (time * rate) );
	float noise = cos(p.x*1000.0+cos(p.y*489.9+time+p.x*50.0)*1450.0);

	//could use cosine to "discard" as well
	
	vec3 dry = texture2D(texture, vertTexCoord.st).xyz * vertColor.xyz;

	float norm = distance(dry.xyz, vec3(0.0));
	
	if (norm < floor) { discard; } //{norm = 0.0;}
	else if (norm >= ceil) {norm = 1.0;}
	

	vec3 filter;
	if ( d > circle_radius )
	{
		filter = vec3(norm) * vec3(noise);
	}
	
	else if ( d < (circle_radius - border) && norm < .8)
	{
		//discard;
	}

	else if (r >= .5)
	{
		filter = vec3(norm) * vec3(noise) * color;
	}

	gl_FragColor = vec4(filter, alpha);

}

/*
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
*/