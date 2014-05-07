#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

varying vec2 surfacePosition;
uniform float time;
uniform float alpha;


const float color_intensity = 0.085;
const float Pi = 3.14159;

void main()
{
  vec2 p=(0.3*surfacePosition);
  for(int i=1;i<3;i++)
  {
    	vec2 newp=p;
	float ii = float(i);  
    	newp.x+=1.37/ii*sin(ii*Pi*p.y+time*.133+cos((time/(3.*ii))*ii));
    	newp.y+=1000./ii*cos(ii*Pi*p.x+time*.111+sin((time/(6.*ii))*ii));
    	p=newp;
  }
  vec3 col=vec3(cos(p.x+p.y+.9)*.48+.48,sin(p.x+p.y+4.)*.5+.5,(sin(p.x+p.y+9.)+tan(p.x+p.y+12.))*.3+.0);
  gl_FragColor= texture2D(texture, vertTexCoord.st) * vec4(col*col, alpha) * vertColor;
}