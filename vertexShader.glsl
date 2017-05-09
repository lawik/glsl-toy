// varying vec2 vUv;
varying vec2 texCoord;

void main()
{
    // vUv = uv;

    vec4 mvPosition = modelViewMatrix * vec4(position, 1.0 );
    gl_Position = projectionMatrix * mvPosition;

    texCoord = (vec2( gl_Position.x, gl_Position.y )
             + vec2( 1.0 ) ) / vec2( 2.0 );
}

// void main(void)
// {
//    gl_Position = vec4( gl_Vertex.xy, 0.0, 1.0 );
//    gl_Position = sign( gl_Position );

//    texCoord = (vec2( gl_Position.x, gl_Position.y )
//              + vec2( 1.0 ) ) / vec2( 2.0 );
// }
