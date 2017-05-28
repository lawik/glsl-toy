uniform float iGlobalTime;
uniform float iWidth;
uniform float iHeight;
uniform sampler2D iChannel0;

varying vec2 vUv;

void main(void) {
  vec4 textureColor = texture2D(iChannel0, vUv*4.0);
  vec4 textureColor2 = texture2D(iChannel0, vec2(vUv.x+iGlobalTime/10.0, vUv.y+iGlobalTime/5.0));
  vec3 blended = blendMultiply(textureColor.rgb, textureColor2.rgb);
  gl_FragColor = vec4(blended, 1.0);
  // gl_FragColor.a = 0.5;
}
