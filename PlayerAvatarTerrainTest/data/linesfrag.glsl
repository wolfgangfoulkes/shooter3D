//texfrag.glsl:

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float time;
uniform float bin; //?

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void)
{
	
	if (mod(gl_FragCoord.y + (time * (bin * 10.0)), bin) <= 1.0)
        //every second + (0-1?) we return to zero.
        //it'll be less than one when time + fragCoord is < .03
        //gl_FragCoord.y is, I think, 0-1 by range of screen
    {
        gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(0,0,0,0.1);
    }
	else
    {
		
		gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(1.0, 0, 1.0, 1.0);
	}
}