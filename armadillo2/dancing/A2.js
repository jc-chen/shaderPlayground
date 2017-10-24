// SETUP RENDERER & SCENE
var canvas = document.getElementById('canvas');
var scene = new THREE.Scene();
var renderer = new THREE.WebGLRenderer();
renderer.setClearColor(0xFFFFFF); // white background colour
canvas.appendChild(renderer.domElement);

// SETUP CAMERA
var camera = new THREE.PerspectiveCamera(30,1,0.1,1000); // view angle, aspect ratio, near, far
camera.position.set(-30, 5, -5);
camera.lookAt(scene.position);
scene.add(camera);

// SETUP ORBIT CONTROLS OF THE CAMERA
var controls = new THREE.OrbitControls(camera);
controls.damping = 0.2;
controls.autoRotate = false;

// ADAPT TO WINDOW RESIZE
function resize() {
  renderer.setSize(window.innerWidth,window.innerHeight);
  camera.aspect = window.innerWidth/window.innerHeight;
  camera.updateProjectionMatrix();
}

// EVENT LISTENER RESIZE
window.addEventListener('resize',resize);
resize();

//SCROLLBAR FUNCTION DISABLE
window.onscroll = function () {
     window.scrollTo(0,0);
   }

// WORLD COORDINATE FRAME: other objects are defined with respect to it
var worldFrame = new THREE.AxisHelper(3) ;
scene.add(worldFrame);


// LOAD OBJ ROUTINE
function loadOBJ(file, material, scale, xOff, yOff, zOff, xRot, yRot, zRot) {
  var onProgress = function(query) {
    if ( query.lengthComputable ) {
      var percentComplete = query.loaded / query.total * 100;
      console.log( Math.round(percentComplete, 2) + '% downloaded' );
    }
  };

  var onError = function() {
    console.log('Failed to load ' + file);
  };

  var loader = new THREE.OBJLoader();
  loader.load(file, function(object) {
    object.traverse(function(child) {
      if (child instanceof THREE.Mesh) {
        child.material = material;
      }
    });

    object.position.set(xOff,yOff,zOff);
    object.rotation.x= xRot;
    object.rotation.y = yRot;
    object.rotation.z = zRot;
    object.scale.set(scale,scale,scale);
    object.parent = worldFrame;
    scene.add(object);

  }, onProgress, onError);
}


// UNIFORMS
var lightPosition = {type: 'v3', value: new THREE.Vector3(0,5,-3)};
var armadilloPosition = {type: 'v3', value: new THREE.Vector3(0,0,0)};
var rightLegAngle = {type: 'f', value: 0.0};
var leftLegAngle = {type: 'f', value: 0.0};

// MATERIALS
var armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightPosition: lightPosition,
    armadilloPosition: armadilloPosition
  },
});

var armadillo2Material = new THREE.ShaderMaterial({
  uniforms: {
    lightPosition: lightPosition,
    armadilloPosition: armadilloPosition
  },
});

var legMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightPosition: lightPosition,
    armadilloPosition: armadilloPosition,
    rightLegAngle: rightLegAngle,
    leftLegAngle: leftLegAngle
  },
});

var lightbulbMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightPosition: lightPosition,
  },
});

var floorMaterial = new THREE.ShaderMaterial({ 
  //map: floorTexture,
  uniforms: {
    armadilloPosition: armadilloPosition,
    rightLegAngle: rightLegAngle,
    leftLegAngle: leftLegAngle
  },
  side: THREE.DoubleSide,
});

// TULLE SKIRT TEXTURE
var skirtTexture = new THREE.ImageUtils.loadTexture('images/skirt.jpg');
skirtTexture.wrapS = skirtTexture.wrapT = THREE.RepeatWrapping;

// BODICE TEXTURE
var bodiceTexture = new THREE.ImageUtils.loadTexture('images/bodice.jpg');

var skirtMaterial = new THREE.MeshBasicMaterial({
  side: THREE.DoubleSide,
  map: skirtTexture,
});

var bodiceMaterial = new THREE.MeshBasicMaterial({
  side: THREE.DoubleSide,
  map: bodiceTexture,
});

// LOAD SHADERS
var shaderFiles = [
  'glsl/armadillo.vs.glsl',
  'glsl/armadillo.fs.glsl',
  'glsl/leg.vs.glsl',
  'glsl/leg.fs.glsl',
  'glsl/floor.vs.glsl',
  'glsl/floor.fs.glsl',
  'glsl/armadillo2.vs.glsl',
  'glsl/armadillo2.fs.glsl',
  'glsl/skirt.vs.glsl',
  'glsl/skirt.vs.glsl',
];

new THREE.SourceLoader().load(shaderFiles, function(shaders) {
  armadilloMaterial.vertexShader = shaders['glsl/armadillo.vs.glsl'];
  armadilloMaterial.fragmentShader = shaders['glsl/armadillo.fs.glsl'];

  legMaterial.vertexShader = shaders['glsl/leg.vs.glsl'];
  legMaterial.fragmentShader = shaders['glsl/leg.fs.glsl'];

  floorMaterial.vertexShader = shaders['glsl/floor.vs.glsl'];
  floorMaterial.fragmentShader = shaders['glsl/floor.fs.glsl'];

  armadillo2Material.vertexShader = shaders['glsl/armadillo2.vs.glsl'];
  armadillo2Material.fragmentShader = shaders['glsl/armadillo2.fs.glsl'];
})

loadOBJ('obj/armadillo.obj', armadilloMaterial, 1, 0, 0, 0, 0, 0, 0); // Armadillo

loadOBJ('obj/armadillo.obj', legMaterial, 1, 0, 0, 0, 0, 0, 0); // Armadillo

loadOBJ('obj/armadillo.obj', armadillo2Material, 1, 0, 0, -1.25, 0, Math.PI, 0); // Armadillo



var floorGeometry = new THREE.PlaneGeometry(30,30,500,500);
var floor = new THREE.Mesh(floorGeometry, floorMaterial);
floor.position.set(0,0,0);
floor.rotation.set(Math.PI/2,0,0);
scene.add(floor);

var theta = {type: 'f', value: 0.0};

var skirtGeometry = new THREE.SphereGeometry(1.6,10,5,0,2*Math.PI,0,Math.PI/2);
var skirt = new THREE.Mesh(skirtGeometry, skirtMaterial);
skirt.scale.set(0.95,1.05,0.95);
skirt.position.set(0,0,-1.5);
scene.add(skirt);


var bodiceGeometry = new THREE.CylinderGeometry(0.5,0.2,0.6,30,2);
var bodice = new THREE.Mesh(bodiceGeometry,bodiceMaterial);
bodice.scale.set(1.05,1.0,0.9);
bodice.position.set(0.0,1.725,-1.41);
scene.add(bodice);


// LISTEN TO KEYBOARD
var keyboard = new THREEx.KeyboardState();
function checkKeyboard() {
  if (keyboard.pressed("S")) {
    theta.value -= 0.375;
    rightLegAngle.value = Math.sin(theta.value)/2.0;
    armadilloPosition.value.z -= 0.2;
    skirt.position.z -=0.2;
    bodice.position.z -= 0.2;
    leftLegAngle.value = -Math.sin(theta.value)/2.0;
  }

  else if (keyboard.pressed("W")) {
    theta.value += 0.375;
    rightLegAngle.value = Math.sin(theta.value)/2.0;
    armadilloPosition.value.z += 0.2;
    skirt.position.z += 0.2;
    bodice.position.z += 0.2;
    leftLegAngle.value = -Math.sin(theta.value)/2.0;
  }

  if (keyboard.pressed("D")) {
    armadilloPosition.value.x -= 0.1;
    skirt.position.x -= 0.1;
    bodice.position.x -= 0.1;
  }
  else if (keyboard.pressed("A")) {
    armadilloPosition.value.x += 0.1;
    skirt.position.x += 0.1;
    bodice.position.x += 0.1;
  }

  armadilloMaterial.needsUpdate = true;
  legMaterial.needsUpdate = true;
  floorMaterial.needsUpdate = true;
}

// Set up background image
var backgroundTexture = THREE.ImageUtils.loadTexture('images/background.jpg');
var backgroundMesh = new THREE.Mesh(
  new THREE.PlaneGeometry(2,2,0),
  new THREE.MeshBasicMaterial({
    map: backgroundTexture
  }),
);

backgroundMesh.material.depthTest = false;
backgroundMesh.material.depthWrite = false;
var backgroundScene = new THREE.Scene();
var backgroundCamera = new THREE.Camera();
backgroundCamera.lookAt(backgroundScene.position);
backgroundScene.add(backgroundCamera);
backgroundScene.add(backgroundMesh);


// SETUP UPDATE CALL-BACK
function update() {
  checkKeyboard();
  requestAnimationFrame(update);
  renderer.autoClear = false;
  renderer.clear();
  renderer.render(backgroundScene,backgroundCamera);
  renderer.render(scene, camera);
};

update();

