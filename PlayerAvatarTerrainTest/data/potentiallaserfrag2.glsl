#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float time;
uniform vec2 resolution;
uniform float alpha;

void main( void )
{

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.6;
	color += sin( position.x * cos( time / 10.0 ) * 9800.0 ) + cos( position.y * cos( time / 1500.0 ) * 10.0 );
	
	color *= cos( time / 300.0 ) * 0.5;

	gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4( vec3( color + color * 9.0, color * 0.5, tan( color + time / 9.0 ) * 0.75 ), alpha );

}