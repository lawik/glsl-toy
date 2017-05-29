uniform float iGlobalTime;
uniform vec4 iColor;
uniform float iRadius;
uniform float iWidth;
uniform float iHeight;

varying vec2 vUv;
varying vec3 vecPos;
varying vec2 vPosition;

void main(void) {
  float radius = iRadius;
  if(radius > iWidth) {
    radius = iWidth/2.0;
  }
  if(radius > iHeight) {
    radius = iHeight/2.0;
  }

  vec2 tl_pos = vec2(iRadius/2.0, iRadius/2.0);
  float dist = sqrt(dot(vecPos.xy, vecPos.xy));
  gl_FragColor = iColor;
  if ((dist > iRadius+10.0 || dist < (iRadius+10.0))) {
    gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
  } else {
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
  }
  if(vecPos.x < 5.0) {
    gl_FragColor.b = 1.0;
  }
  if(vecPos.y < 5.0) {
    gl_FragColor.g = 1.0;
  }
}
