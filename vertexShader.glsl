uniform float iGlobalTime;
uniform vec4 iColor;

varying vec2 vUv;
varying vec3 vecPos;
varying vec3 vecNormal;
varying vec2 vPosition;

void main() {
  // float maxHeight = 32.0;
  vUv = uv;
  // // Since the light is in camera coordinates,
  // // I'll need the vertex position in camera coords too
  vecPos = (modelViewMatrix * vec4(position, 1.0)).xyz;
  // // That's NOT exacly how you should transform your
  // // normals but this will work fine, since my model
  // // matrix is pretty basic
  vecNormal = (modelViewMatrix * vec4(normal, 0.0)).xyz;

  vPosition = position.xy;

  // float intensity_1 = snoise(
  //   vec2(
  //       (position.x/512.0)+(iGlobalTime/4.0),
  //       (position.y/512.0)
  //   )
  // );
  // float intensity_2 = snoise(
  //   vec2(
  //       (position.x/256.0)+(iGlobalTime/8.0),
  //       (position.y/256.0)+(sin(iGlobalTime/4.0))
  //   )
  // );

  // float intensity = (intensity_1 + intensity_2)/2.0;

  // gl_Position = projectionMatrix * vec4(vecPos.xy, vecPos.z+(intensity*maxHeight), 1.0);
  gl_Position = projectionMatrix * vec4(vecPos.xyz, 1.0);
}
