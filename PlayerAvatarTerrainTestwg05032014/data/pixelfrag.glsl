#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

uniform float time;
uniform vec2 pixels;

void main( void ) {

	int si = int(vertTexCoord.s * pixels.x);
    int sj = int(vertTexCoord.t * pixels.y);

	gl_FragColor = texture2D(texture, vec2(float(si) / pixels.x, float(sj) / pixels.y)) * vertColor;

}