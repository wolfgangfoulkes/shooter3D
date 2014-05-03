#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform float time;
uniform vec2 resolution;

#define pi 3.14159265
#define SPEED 1.0

float frequencyChange =  .001;
float frequencyChangeChange = .1;
float frequencyR = 0.0;
float frequencyG = 0.0;
float frequencyB = 0.0;

void main()
{
	float x = gl_FragCoord.x;
	float y = gl_FragCoord.y;
	frequencyChange = frequencyChangeChange * (50000.0 * (y + time/200.0)) + 		frequencyChangeChange * (x / resolution.x);
	frequencyR += frequencyChange / 1920.0;
	frequencyG += frequencyChange / 1920.0;
	frequencyB += frequencyChange / 1920.0;
  	float r = (sin(frequencyR*x) + 1.0) / 2.0;
	float g = (sin(frequencyG*x + 2.0*pi/3.0) + 1.0) / 2.0; 
	float b = (sin(frequencyB*x + 4.0*pi/3.0) + 1.0) / 2.0;
	//perform the same operations on each to get black/white
	//gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(r, r, r, 1.0);
    gl_FragColor = vec4(r, r, r, 1.0);
}