/*
 * UBC CPSC 314, Vsep2017
 * Assignment 1 Template
 */

// SETUP RENDERER & SCENE
var canvas = document.getElementById('canvas');
var scene = new THREE.Scene();
var renderer = new THREE.WebGLRenderer();
renderer.setClearColor(0xFFFFFF); // white background colour
canvas.appendChild(renderer.domElement);

// SETUP CAMERA
var camera = new THREE.PerspectiveCamera(30,1,0.1,1000); // view angle, aspect ratio, near, far
camera.position.set(45,20,40);
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
var worldFrame = new THREE.AxisHelper(5) ;
scene.add(worldFrame);

// FLOOR WITH PATTERN
var floorTexture = new THREE.ImageUtils.loadTexture('images/floor.jpg');
floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping;
floorTexture.repeat.set(1, 1);

var floorMaterial = new THREE.MeshBasicMaterial({ map: floorTexture, side: THREE.DoubleSide });
var floorGeometry = new THREE.PlaneBufferGeometry(30, 30);
var floor = new THREE.Mesh(floorGeometry, floorMaterial);
floor.position.y = -0.1;
floor.rotation.x = Math.PI / 2;
scene.add(floor);
floor.parent = worldFrame;


// WALLS
var wallTexture = new THREE.ImageUtils.loadTexture('images/wall.jpg');
wallTexture.wrapS = wallTexture.wrapT = THREE.RepeatWrapping;
wallTexture.repeat.set(1, 1);

var wallMaterial = new THREE.MeshBasicMaterial({ map: wallTexture, side: THREE.DoubleSide });
var wallGeometry = new THREE.PlaneBufferGeometry(30, 30);
var wall1 = new THREE.Mesh(wallGeometry, wallMaterial);
wall1.position.y = 15;
wall1.position.z = -15;
wall1.rotation.x = Math.PI;
scene.add(wall1);
wall1.parent = worldFrame;

var wall2 = new THREE.Mesh(wallGeometry, wallMaterial);
wall2.position.y = 15;
wall2.position.x = -15;
wall2.rotation.x = Math.PI;
wall2.rotation.z = Math.PI/2;
wall2.rotation.y = Math.PI/2;
scene.add(wall2);
wall2.parent = worldFrame;

var wall3 = new THREE.Mesh(wallGeometry, wallMaterial);
wall3.position.y = 15;
wall3.position.x = 15;
wall3.rotation.x = Math.PI;
wall3.rotation.z = Math.PI/2;
wall3.rotation.y = Math.PI/2;
scene.add(wall3);
wall3.parent = worldFrame;

/////////////////////////////////
//   YOUR WORK STARTS BELOW    //
/////////////////////////////////

// UNIFORMS
var lightPosition = {type: 'v3', value: new THREE.Vector3(0,5,3)};
var discoBallRotation = {type: 'v3', value: new THREE.Vector3(0,0,0)};
var armadilloPosition = {type: 'v3', value: new THREE.Vector3(0,0,0)};


// MATERIALS
var armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
      lightPosition: lightPosition,
      armadilloPosition: armadilloPosition,
  },
});
var lightbulbMaterial = new THREE.ShaderMaterial({
   uniforms: {
    lightPosition: lightPosition,
  },
});
var discoBallMaterial = new THREE.ShaderMaterial({
   uniforms: {
    lightPosition: lightPosition,
    discoBallRotation: discoBallRotation,
  },
});

// LOAD SHADER
var shaderFiles = [
  'glsl/armadillo.vs.glsl',
  'glsl/armadillo.fs.glsl',
  'glsl/lightbulb.vs.glsl',
  'glsl/lightbulb.fs.glsl',
  'glsl/discoBall.vs.glsl',
  'glsl/discoBall.fs.glsl'
];

new THREE.SourceLoader().load(shaderFiles, function(shaders) {
  armadilloMaterial.vertexShader = shaders['glsl/armadillo.vs.glsl'];
  armadilloMaterial.fragmentShader = shaders['glsl/armadillo.fs.glsl'];

  lightbulbMaterial.vertexShader = shaders['glsl/lightbulb.vs.glsl'];
  lightbulbMaterial.fragmentShader = shaders['glsl/lightbulb.fs.glsl'];

  discoBallMaterial.vertexShader = shaders['glsl/discoBall.vs.glsl'];
  discoBallMaterial.fragmentShader = shaders['glsl/discoBall.fs.glsl'];
})

// LOAD ARMADILLO
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

loadOBJ('obj/armadillo.obj', armadilloMaterial, 3, 0,3,0, 0,Math.PI,0);

// CREATE light
var lightbulbGeometry = new THREE.SphereGeometry(1, 32, 32);
var lightbulb = new THREE.Mesh(lightbulbGeometry, lightbulbMaterial);
lightbulb.parent = worldFrame;
scene.add(lightbulb);

// CREATE disco ball
// NOTE: The polyhedron geometry is taken from three.js documentation
var vertices = [
    -1,-1,-1,    1,-1,-1,    1, 1,-1,    -1, 1,-1,
    -1,-1, 1,    1,-1, 1,    1, 1, 1,    -1, 1, 1
];
var indices = [
    2,1,0,    0,3,2,
    0,4,7,    7,3,0,
    0,1,5,    5,4,0,
    1,2,6,    6,5,1,
    2,3,7,    7,6,2,
    4,5,6,    6,7,4
];

var discoBallGeometry = new THREE.PolyhedronGeometry(vertices,indices,2,2); 
var discoBall = new THREE.Mesh(discoBallGeometry, discoBallMaterial);
discoBall.parent = worldFrame;
discoBall.position.y=15;
scene.add(discoBall);

// LISTEN TO KEYBOARD
var keyboard = new THREEx.KeyboardState();
function checkKeyboard() {
  if (keyboard.pressed("W"))
    lightPosition.value.z -= 0.1;
  else if (keyboard.pressed("S"))
    lightPosition.value.z += 0.1;

  if (keyboard.pressed("A"))
    lightPosition.value.x -= 0.1;
  else if (keyboard.pressed("D"))
    lightPosition.value.x += 0.1;

  if (keyboard.pressed("E"))
    lightPosition.value.y -= 0.1;
  else if (keyboard.pressed("Q"))
    lightPosition.value.y += 0.1;

  lightbulbMaterial.needsUpdate = true; // Tells three.js that some uniforms might have changed
}

function party() {
  discoBallRotation.value.x += 0.3;
  discoBallMaterial.needsUpdate = true;
  armadilloPosition.value.x += 0.05;
  armadilloPosition.value.y += 0.1;
}

// SETUP UPDATE CALL-BACK
function update() {
  checkKeyboard();
  party();
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

update();

