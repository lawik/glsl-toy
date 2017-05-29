uniform float iGlobalTime;
uniform float iWidth;
uniform float iHeight;

uniform sampler2D iChannel0;
uniform sampler2D iChannel2;

varying vec2 vUv;
varying vec3 vecPos;

void main(void) {

  // gl_FragColor = texture2D(iChannel2, vUv);
  vec4 textureColor_1 = texture2D(iChannel0,
    vec2(
      vUv.x - iGlobalTime/100.0,
      vUv.y - cos(iGlobalTime/100.0)
    )*4.0
  );
  //-vUv*4.0
  vec4 textureColor_2 = texture2D(iChannel0,
    vec2(
      vUv.x + iGlobalTime/100.0,
      vUv.y + sin(iGlobalTime/100.0)
    )*4.0
  );

  gl_FragColor = vec4(
    blendOverlay(
      textureColor_1.rgb,
      textureColor_2.rgb
    ).rgb,
    1.0
  );

  // vec4 textureColor2 = texture2D(iChannel2, vec2(vUv.x+iGlobalTime/10.0, vUv.y+iGlobalTime/5.0));
  // vec3 blended = blendMultiply(textureColor.rgb, textureColor2.rgb);
  // gl_FragColor = vec4(blended, 1.0);
  // gl_FragColor.a = 0.5;


  // float intensity_1 = snoise(
  //   vec2(
  //       (vecPos.x/128.0)+(iGlobalTime/4.0),
  //       (vecPos.y/128.0)
  //   )
  // );
  // float intensity_2 = snoise(
  //   vec2(
  //       (vecPos.x/64.0)+(iGlobalTime/8.0),
  //       (vecPos.y/64.0)+(sin(iGlobalTime/4.0))
  //   )
  // );

  // float intensity = (intensity_1 + intensity_2)/2.0;

  // gl_FragColor = vec4(intensity, intensity, intensity, 1.0);
}
