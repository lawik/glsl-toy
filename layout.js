function Layout(scene, ready) {
    var self = this;
    self.scene = scene;
    self.clock = new THREE.Clock();
    self.time = 0.1;
    self.fragmentShader = false;
    self.vertexShader = false;

    self.elements = [];

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
                                self.fragmentShader = toolsCode + blendModesCode + fragmentShader;
                                self.vertexShader = vertexShader;
                                // this.vertexShader = toolsCode + blendModesCode + vertexShader;
                                ready(self);
                            });
                        }
                    });
                }
            });
        }
    });

    self.update = function () {
        if(self.fragmentShader && self.vertexShader) {
            self.time += self.clock.getDelta();
            for(var i in self.elements) {
                var element = self.elements[i];
                element.uniforms.iGlobalTime.value = self.time;
            }
        }
    };

    self.addElement = function (x, y, width, height, color, options) {
        var element = new Element(self, x, y, width, height, color, options);
        self.elements.push(element);
        self.scene.add(element.mesh);

        return element;
    };
}

function Element(layout, x, y, width, height, color, options) {
    if(options == undefined) {
        options = {};
    }
    this.geometry = new THREE.PlaneGeometry(width, height);

    this.uniforms = {
        iGlobalTime: { type: 'f', value: this.time },
        iColor: { type: 'v4', value: color },
        iWidth: { type: 'f', value: width },
        iHeight: { type: 'f', value: height },
        iRadius: { type: 'f', value: 0.0 }
    };

    if(options.radius !== undefined) {
        this.uniforms.iRadius = options.radius;
    }

    this.material = new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: layout.vertexShader,
        fragmentShader: layout.fragmentShader
    });

    this.material.transparent = true;
    this.material.blending = THREE.NormalBlending;
    this.mesh = new THREE.Mesh( this.geometry, this.material);

    this.mesh.position.x = x + (width / 2);  // Make offset from left edges
    this.mesh.position.y = -y - (height / 2); // Make offset from top edges
}
