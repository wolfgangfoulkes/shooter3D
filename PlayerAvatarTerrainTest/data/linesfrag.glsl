#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float mod;
uniform float size;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ); //unused
	vec2 start_pos = vec2(0 ,resolution.y); //unused
	
	if (mod(gl_FragCoord.x + (time * 1000.0), mod) < size)
	//time is in milliseconds
	//alter time mult to change rate
	//alter the value we mod by to change size of black bars
	//alter the value we compare it against to change size of white bars 
	{
		gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(1.0, 1.0, 1.0, 1.0);
	}	
	else
	{
		gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(0, 0, 0, 0.0);
	}

}