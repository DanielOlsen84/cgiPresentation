uniform mat4 vm; //viewMatrix
uniform float time;

uniform float screenScale;

uniform float waveScale;

//uniform float infinite;

uniform mat4 EyeToLightMatrix;
uniform mat4 EyeToLightMatrix2;
varying vec4 ShadowTexCoord2;    

uniform float CameraViewDir;

const float infinite = 160000.0; 
//const float infinite = 20000000.0; 
//const float screenScale =  0.1; 
//const float screenScale = 1.05; 
const vec3 groundNormal = vec3( 0.0, -1.0, 0.0 ); 
const float groundHeight = 0.0; 

uniform vec2 Wave1Direction;
uniform vec4 Wave1Values;
uniform vec2 Wave2Direction;
uniform vec4 Wave2Values;
uniform vec2 Wave3Direction;
uniform vec4 Wave3Values;
uniform vec2 Wave4Direction;
uniform vec4 Wave4Values;
uniform vec2 Wave5Direction;
uniform vec4 Wave5Values;
uniform vec2 Wave6Direction;
uniform vec4 Wave6Values;
uniform vec2 Wave7Direction;
uniform vec4 Wave7Values;
uniform vec2 Wave8Direction;
uniform vec4 Wave8Values;

varying vec3 vCamPosition; 
varying vec3 Texcoord;
varying vec3 vWorldPosition;
//varying vec4 vReflectCoordinates;
varying vec4 refTexcoord;
varying vec3 v_texCoord3D;

//varying vec3 gerstnerNormal;


vec3 gerstner_wave_position(vec2 position, float time) {
vec3 wave_position = vec3(position.x, 0, position.y);

//wave1
float proj = dot(position, Wave1Direction.xy);
float phase = time * Wave1Values.w;
float theta = proj * Wave1Values.z + phase;
float height = Wave1Values.x * sin(theta);

wave_position.y += height;

float maximum_width = Wave1Values.y * Wave1Values.x * 2.0;
float width = maximum_width * cos(theta);
float x = Wave1Direction.x;
float y = Wave1Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave2
proj = dot(position, Wave2Direction.xy);
phase = time * Wave2Values.w;
theta = proj * Wave2Values.z + phase;
height = Wave2Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave2Values.y * Wave2Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave2Direction.x;
y = Wave2Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave3
proj = dot(position, Wave3Direction.xy);
phase = time * Wave3Values.w;
theta = proj * Wave3Values.z + phase;
height = Wave3Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave3Values.y * Wave3Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave3Direction.x;
y = Wave3Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave4
proj = dot(position, Wave4Direction.xy);
phase = time * Wave4Values.w;
theta = proj * Wave4Values.z + phase;
height = Wave4Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave4Values.y * Wave4Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave4Direction.x;
y = Wave4Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave5
proj = dot(position, Wave5Direction.xy);
phase = time * Wave5Values.w;
theta = proj * Wave5Values.z + phase;
height = Wave5Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave5Values.y * Wave5Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave5Direction.x;
y = Wave5Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave6
proj = dot(position, Wave6Direction.xy);
phase = time * Wave6Values.w;
theta = proj * Wave6Values.z + phase;
height = Wave6Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave6Values.y * Wave6Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave6Direction.x;
y = Wave6Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave7
proj = dot(position, Wave7Direction.xy);
phase = time * Wave7Values.w;
theta = proj * Wave7Values.z + phase;
height = Wave7Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave7Values.y * Wave7Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave7Direction.x;
y = Wave7Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

//wave8
proj = dot(position, Wave8Direction.xy);
phase = time * Wave8Values.w;
theta = proj * Wave8Values.z + phase;
height = Wave8Values.x * sin(theta);

wave_position.y += height;

maximum_width = Wave8Values.y * Wave8Values.x * 2.0;
width = maximum_width * cos(theta);
x = Wave8Direction.x;
y = Wave8Direction.y;

wave_position.x += x * width;
wave_position.z += y * width;

return wave_position;
}

//vec3 gerstner_wave(vec2 position, float time, inout vec3 normal) {
//    vec3 wave_position = gerstner_wave_position(position, time);
 //   normal = gerstner_wave_normal(wave_position, time);
  //  return wave_position; // Accumulated Gerstner Wave.
//}

vec3 gerstner_wave(vec2 position, float timel) {
    vec3 wave_position = gerstner_wave_position(position, time);
    //normal = gerstner_wave_normal(wave_position, time);
   return wave_position; // Accumulated Gerstner Wave.
}

vec3 interceptPlane( in vec3 source, in vec3 dir, in vec3 normal, float height ) 
{ 
// Compute the distance between the source and the surface, following a ray, then return the intersection
   // http://www.cs.rpi.edu/~cutler/classes/advancedgraphics/S09/lectures/11_ray_tracing.pdf

	float distance = ( - height - dot( normal, source ) ) / dot( normal, dir ); 
                   
	if( distance < 0.0 ) 
		return source + dir * distance; 
	else  
		return - ( vec3( source.x, height, source.z ) + vec3( dir.x, height, dir.z ) * infinite ); 
} 

mat3 getRotation() 
{ 
// Extract the 3x3 rotation matrix from the 4x4 view matrix
	return mat3(  
		vm[0].xyz, 
		vm[1].xyz, 
		vm[2].xyz 
	); 
} 
	
vec3 getCameraPos( in mat3 rotation ) 
{ 
// Xc = R * Xw + t
// c = - R.t() * t <=> c = - t.t() * R
	return - vm[3].xyz * rotation; 
} 

vec2 getImagePlan() 
{ 
// Extracting aspect and focal from projection matrix:
// P = | e   0       0   0 |
//     | 0   e/(h/w) 0   0 |
//     | 0   0       .   . |
//     | 0   0       -1  0 |
	float focal = gl_ProjectionMatrix[0].x; 
	float aspect = gl_ProjectionMatrix[1].y; 

// Fix coordinate aspect and scale
	return vec2( ( gl_MultiTexCoord0.x - 0.5 ) * screenScale * aspect, ( gl_MultiTexCoord0.y - 0.5 ) * screenScale * focal ); 
} 

vec3 getCamRay( in mat3 rotation, in vec2 screenUV ) 
{ 
// Compute camera ray then rotate it in order to get it in world coordinate
	return vec3( screenUV.x, screenUV.y, gl_ProjectionMatrix[0].x ) * rotation; 
} 

vec3 computeProjectedPosition() 
{ 
	// Extract camera position and rotation from the model view matrix
	mat3 cameraRotation = getRotation(); 
	vec3 camPosition = getCameraPos( cameraRotation ); 
	vCamPosition = camPosition; 

// Return the intersection between the camera ray and a given plane
	if( camPosition.y < groundHeight ) 
		return vec3( 0.0, 0.0, 0.0 ); 

	// Extract coordinate of the vertex on the image plan
	vec2 screenUV = getImagePlan() ; 
		
	// Compute the ray from camera to world
	vec3 ray = getCamRay( cameraRotation, screenUV ); 	
		
	vec3 finalPos = interceptPlane( camPosition, ray, groundNormal, groundHeight );

	float distance = length( finalPos );
                   //finalPos.w = distance;
	if( distance > infinite ) 
		finalPos *= infinite / distance;

	return finalPos;
}

void main() {

//vec4 screenPlaneWorldPosition = vec4( computeProjectedPosition(), 1.0 );
vec3 v = computeProjectedPosition();

v.x = v.x - cos((CameraViewDir) * 3.1415 /180.0) * (10.0 + waveScale);
v.z = v.z - sin((CameraViewDir) * 3.1415 /180.0) * (10.0 + waveScale);

//vec3 pp = gerstner_wave(v.xz, time, gerstnerNormal);
vec3 pp = gerstner_wave(v.xz, time);
pp.y = pp.y * waveScale; //FOR HIGHER WAVES	

vec4 posMVP = gl_ProjectionMatrix * vm * vec4(pp.xyz, 1.0);

float myDistance = posMVP.z;

if (myDistance > 3000.0)
{
pp.y = 0.0;
}
else
{
pp.y = 0.0 + (pp.y * (1 - (myDistance / 3000.0)));
}

//gl_Position = vm * vec4(pp.xyz, 1.0);
//vec4 preCom = vm * vec4(pp.xyz, 1.0);
//preCom.z += 10.0;
//preCom.y = 0.0;
//gl_Position = gl_ProjectionMatrix * preCom;

gl_Position = gl_ProjectionMatrix * vm * vec4(pp.xyz, 1.0);

vWorldPosition = pp.xyz;
Texcoord = pp.xyz;
	
//refTexcoord = (gl_ProjectionMatrix * vm * vec4(pp.xyz, 1.0));
refTexcoord = gl_ProjectionMatrix * vm * vec4(pp.xyz, 1.0);

//vec4 Pe = gl_ModelViewMatrix * gl_Vertex;
vec4 Pe = vm * vec4(pp.xyz, 1.0);
      gl_TexCoord[1] =  EyeToLightMatrix * Pe;
     ShadowTexCoord2 =  EyeToLightMatrix2 * Pe;

}

