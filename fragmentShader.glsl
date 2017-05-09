uniform float iGlobalTime;
uniform float iWidth;
uniform float iHeight;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;

// varying vec2 vUv;
varying vec2 texCoord;

vec3 _4to3(vec4 inp) {
    return vec3(inp.r, inp.g, inp.b);
}

vec4 _3to4(vec3 inp) {
    return vec4(inp.r, inp.g, inp.b, 1.0);
}

float rerange(float value, float low1, float high1, float low2, float high2) {
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
}

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
        + i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

void main(void)
{
    // float gradientIntensity = clamp(gl_FragCoord.x/iWidth, 0.0, 1.0);
    // float timeSineScale = rerange(sin(iGlobalTime), -1.0, 1.0, 0.0, 1.0);
    // gradientIntensity = timeSineScale * gradientIntensity;
    // gl_FragColor = vec4(
    //     gradientIntensity,
    //     gradientIntensity,
    //     gradientIntensity,
    //     1.0
    // );

    float intensity = snoise(
        vec2(
            rerange(texCoord.x, 0.0, iWidth, 0.0, 5.0),
            rerange(texCoord.y, 0.0, iWidth, 0.0, 5.0)
        )
    );
    intensity = clamp(intensity, 0.5, 1.0);
    // gl_FragColor = _3to4(
    //     blendScreen(
    //         blendScreen(
    //             _4to3(gl_FragColor),
    //             vec3(intensity, intensity, intensity)
    //         ),
    //         _4to3(
    //             texture2D(
    //                 iChannel0,
    //                 vec2(texCoord.x, texCoord.y)
    //             )
    //         )
    //     )
    // );

    float xDistortion = rerange(sin(iGlobalTime/500.0), -1.0, 1.0, 4.0, 5.0);
    float yDistortion = rerange(sin(iGlobalTime+10.0/450.0), -1.0, 1.0, 3.0, 4.0);

    gl_FragColor = _3to4(
        blendScreen(
            blendMultiply(
                _4to3(
                    texture2D(
                        iChannel0,
                        vec2(
                            // rerange(texCoord.x, 0.0, iWidth, 0.0, 10.0),
                            rerange(texCoord.x, 0.0, iWidth, 0.0, xDistortion),
                            // rerange(texCoord.y, 0.0, iWidth, 0.0, 10.0)
                            rerange(texCoord.y, 0.0, iWidth, 0.0, yDistortion)
                        )
                    )
                ),
                vec3(intensity, intensity, intensity)
            ),
            _4to3(
                texture2D(
                    iChannel1,
                    vec2(
                        // rerange(texCoord.x, 0.0, iWidth, 0.0, 10.0),
                        rerange(texCoord.x, 0.0, iWidth, 0.0, 5.0),
                        // rerange(texCoord.y, 0.0, iWidth, 0.0, 10.0)
                        rerange(texCoord.y, 0.0, iWidth, 0.0, 5.0)
                    )
                )
            )
        )
    );

    // gl_FragColor = vec4(
    //     blendintensity,
    //     intensity,
    //     intensity,
    //     1.0
    // );
    // vec2 p = -1.0 + 2.0 *vUv;
    // vec2 q = p - vec2(0.5, 0.5);

    // q.x += sin(iGlobalTime* 0.6) * 0.2;
    // q.y += cos(iGlobalTime* 0.4) * 0.3;

    // float len = length(q);

    // float a = atan(q.y, q.x) + iGlobalTime * 0.3;
    // float b = atan(q.y, q.x) + iGlobalTime * 0.3;
    // float r1 = 0.3 / len + iGlobalTime * 0.5;
    // float r2 = 0.2 / len + iGlobalTime * 0.5;

    // float m = (1.0 + sin(iGlobalTime * 0.5)) / 2.0;
    // vec4 tex1 = texture2D(iChannel0, vec2(a + 0.1 / len, r1 ));
    // vec4 tex2 = texture2D(iChannel1, vec2(b + 0.1 / len, r2 ));
    // vec3 col = vec3(mix(tex1, tex2, m));
    // gl_FragColor = vec4(col * len * 1.5, 1.0);
}
