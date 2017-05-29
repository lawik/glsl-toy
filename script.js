var scene = new THREE.Scene();
var clock = new THREE.Clock();
var stats = new Stats();
stats.showPanel( 0 ); // 0: fps, 1: ms, 2: mb, 3+: custom
document.body.appendChild( stats.dom );
// var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

var camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / - 2, - 500, 1000 );

var renderer = new THREE.WebGLRenderer( { antialias: true } );
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );

// controls = new THREE.OrbitControls( camera, renderer.domElement );

var width = window.innerWidth;
var height = window.innerHeight;

var size = width/2;
if(height < width) {
    size = height/2;
}

camera.position.x = window.innerWidth/2;
camera.position.y = -(window.innerHeight/2);

var layout = new Layout(scene, function (_layout) {
    _layout.addElement(
        128, 128,
        256, 256,
        new THREE.Vector4(0.5, 0.5, 0.5, 0.5),
        {
            radius: 32.0
        }
    );
    _layout.addElement(
        64, 64,
        32, 32,
        new THREE.Vector4(1.0, 1.0, 1.0, 1.0)
    );

    window.run = true;

    function render() {
        stats.begin();
        layout.update();
        renderer.render( scene, camera );
        stats.end();
        if(window.run) {
            requestAnimationFrame( render );
        }
    }
    window.render = render;
    render();
});
