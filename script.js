function run (vertexShader, fragmentShader) {
    var scene = new THREE.Scene();
    var clock = new THREE.Clock();
    var stats = new Stats();
    stats.showPanel( 0 ); // 0: fps, 1: ms, 2: mb, 3+: custom
    document.body.appendChild( stats.dom );
    var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

    // camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / - 2, - 500, 1000 );

    camera.position.z = 500;

    var renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setSize( window.innerWidth, window.innerHeight );
    document.body.appendChild( renderer.domElement );

    var width = window.innerWidth;
    var height = window.innerHeight;

    // var geometry = new THREE.BoxGeometry( window.innerWidth, window.innerHeight, 32 );
    var size = width/2;
    if(height < width) {
        size = height/2;
    }
    var geometry = new THREE.SphereGeometry(size , 128, 128 );

    // var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );

    var tuniform = {
        iWidth: { type: 'f', value: width },
        iHeight: { type: 'f', value: height },
        iGlobalTime:    { type: 'f', value: 0.1 },
        iChannel0:  { type: 't', value: THREE.ImageUtils.loadTexture( 'stars-2.jpg') },
        // iChannel0:  { type: 't', value: THREE.ImageUtils.loadTexture( 'wood-1.jpg') }
        iChannel1:  { type: 't', value: THREE.ImageUtils.loadTexture( 'stars-1.jpg' ) },
    };
    tuniform.iChannel0.value.wrapS = tuniform.iChannel0.value.wrapT = THREE.RepeatWrapping;
    tuniform.iChannel1.value.wrapS = tuniform.iChannel1.value.wrapT = THREE.RepeatWrapping;

    var material = new THREE.ShaderMaterial( {
        uniforms: tuniform,

        vertexShader: vertexShader,

        fragmentShader: fragmentShader

    } );
    material.transparent = true;
    material.blending = THREE.NormalBlending;
    var mesh = new THREE.Mesh( geometry, material );
    scene.add( mesh );

    // camera.position.z = 5;

    function render() {
        stats.begin();
        mesh.rotation.x += 0.01;
        mesh.rotation.y += 0.01;
        tuniform.iGlobalTime.value += clock.getDelta();
        renderer.render( scene, camera );
        stats.end();
        requestAnimationFrame( render );
    }
    render();
}


function getShader (path, callback) {
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        var DONE = 4;
        var OK = 200;
        if (xhr.readyState === DONE) {
            if (xhr.status === OK) {
                // console.log(xhr.responseText);
                callback(xhr.responseText);
            } else {
                callback(false);
            }
        }
    };

    xhr.open('GET', path);
    xhr.send(null);
}

getShader('vertexShader.glsl', function (vertexShader) {
    if(vertexShader) {
        getShader('blendmodes.glsl', function (blendModesCode) {
            if(blendModesCode) {
                getShader('tools.glsl', function (toolsCode) {
                    if(toolsCode) {
                        getShader('fragmentShader.glsl', function (fragmentShader) {
                            fragmentShader = toolsCode + blendModesCode + fragmentShader;
                            if(fragmentShader) {
                                run(vertexShader, fragmentShader);
                            }
                        });
                    }
                });
            }
        });
    }
});

