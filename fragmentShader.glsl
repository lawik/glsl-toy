uniform float iGlobalTime;
uniform float iWidth;
uniform float iHeight;
uniform sampler2D iChannel0;

varying vec2 vUv;

void main(void) {
  gl_FragColor = texture2D(iChannel0, vUv);
}
