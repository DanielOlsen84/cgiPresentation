uniform float time;
uniform sampler2D mainTex;
uniform sampler2D bump1;
uniform sampler2D bump2;
uniform sampler2D foamTex;
uniform sampler2D wakes;
uniform vec4 sunPos;

uniform vec4 skyColor;
uniform vec4 sunColor;

uniform float sunStrength;

uniform float fogStart;
uniform float fogEnd;
//uniform float fogDensity;
uniform float fogClampLow;
uniform float fogClampHigh;

uniform sampler2DShadow ShadowMap;
uniform sampler2DShadow ShadowMap2;
uniform float myZ;
varying vec4 ShadowTexCoord2;

varying vec3 Texcoord;
varying vec4 refTexcoord;
varying vec3 vWorldPosition;
varying vec3 vCamPosition;

varying vec3 v_texCoord3D;

//varying vec3 gerstnerNormal;

vec3 hdr (vec3 color, float exposure) {
	return 1.0 - exp(-color * exposure);
}

void main() {

vec3 sundir = sunPos.xyz;

vec4 abump1 = texture2D(bump1, vec2(Texcoord.x + time * 22.8,Texcoord.z - time * 14.8) * 0.001);
vec4 abump2 = texture2D(bump1, vec2(Texcoord.x + time * 20.8,Texcoord.z + time * 9.8) * 0.0052);  
vec4 abump3 = texture2D(bump2, vec2(Texcoord.x + time * 10, Texcoord.z + time * 12.0) * 0.0151);
vec4 abump4 = texture2D(bump2, vec2(Texcoord.x + time * 8, Texcoord.z - time * 14.0) * 0.0075);
vec4 abump5 = texture2D(bump1, vec2(Texcoord.x + time * 15.5,Texcoord.z + time * 12.2) * 0.015);
  
//vec4 bump = (abump1 + abump2 + abump3 + abump4 + vec4(gerstnerNormal, 1.0)) * 0.21; 
vec4 bump = (abump1 + abump2 + abump3 + abump4 + abump5 ) * 0.21; 
vec4 refBump = bump;

vec3 reflection = normalize( reflect( -sundir, bump.rgb ) );

bump = normalize(vec4(bump.r * 2 - 1, bump.b, bump.g * 2 - 1, bump.a));

vec4 distBump = bump; // * vec4(gerstnerNormal.xyz, 1.0);

vec3 view = normalize( vCamPosition.xyz - vWorldPosition );

float specularFactor = pow( max( 0.0, dot( view, reflection ) ), 200.0 ) * 20.0;
vec3 distortion = 20.0 * reflection * vec3( 0.19, 0.5, 1.1 );

float distanceRatio = min( 1.0, log( 1.0 / length( vCamPosition - vWorldPosition ) * 3000.0 + 1.0 ) );
distanceRatio *= distanceRatio;
distanceRatio = distanceRatio * 0.7 + 0.3;

bump.xyz = ( distanceRatio * bump.xyz + vec3( 0.0, 1.0 - distanceRatio, 0.0 ) ) * 0.5;
bump /= length( bump );

float fresnel = pow( 1.0 - dot( bump.xyz, view ), 3.0 );

float skyFactor = 3.0 * ( fresnel + 0.2 ); // * 10.0;
	
refTexcoord += refBump ; // * 5.0;

vec2 ndc = (refTexcoord.xy / refTexcoord.w) / 2 + 0.5;

	vec2 refCoord = vec2(-ndc.x, ndc.y);
	
	float distanceFactor = max(length( vCamPosition - vWorldPosition ) / 100, 5);
	vec2 myDistortion = distBump.xz / distanceFactor;
		
                  refCoord = refCoord + myDistortion;
	//vec4 refTexture = texture2D(mainTex, vec2(refCoord.x, refCoord.y));
	//vec3 ndc2 = (refTexcoord.xyz / refTexcoord.w) / 2 + 0.5;
	//refTexture.a = ndc2.z / 2 + 0.5;
	vec4 color3 = mix( skyColor, texture2D(mainTex, vec2(refCoord.x, refCoord.y)), normalize(distanceFactor) - 0.75);
	//vec4 color3 = mix(refTexture, skyColor, normalize(distanceFactor) - 0.9);
	color3 = (color3 * fresnel + 0.1) * 0.5;

vec2 ndc2 = (refTexcoord.xy / refTexcoord.w) / 2 + 0.5;
ndc2 += myDistortion * 0.35;
vec4 wakesColor = texture2D(wakes, vec2(ndc2.x, ndc2.y));

vec3 waterColor = ( 1.0 - fresnel ) * vec3(0.04, 0.16, 0.47);

Texcoord += refBump ; //TEEEEEEEEEEST

vec4 foamTexA = texture2D(foamTex, vec2(Texcoord.x + time * 6.5, Texcoord.z - time * 10.15 ) * 0.025);
vec4 foamTexA2 = texture2D(foamTex, vec2(Texcoord.x - time * 5.5, Texcoord.z + time * 5.15 ) * 0.015);
vec4 foamTexB = texture2D(foamTex, vec2(Texcoord.x + time * 3.7, Texcoord.z - time * 2.1) * 0.075);
vec4 foamTexB2 = texture2D(foamTex, vec2(Texcoord.x - time * 4.7, Texcoord.z + time * 4.1) * 0.15);
//vec4 foamTexC = mix(mix(foamTexA, foamTexB, 0.5), mix(foamTexA2, foamTexB2, 0.5), 0.5);
vec4 foamTexC = (foamTexA + foamTexB + foamTexA2 + foamTexB2) * 0.25;
//foamTexC = clamp(foamTexC, 0.5, 1.0);

//vec3 specColor = vec3(1.0, 1.0, 1.0) * specularFactor;
vec3 specColor = sunColor.rgb * specularFactor;

if (wakesColor.r < 0.1 ) {
wakesColor.rgb = 0.0; }
else {
wakesColor.rgb = wakesColor.rgb + 0.0; }

vec3 color2 = (( skyFactor + specColor + waterColor ) * (color3 * 0.55) + waterColor * 0.75);
//} else {
//vec3 color2 = (( skyFactor + specColor + waterColor ) * wakesColor.rgb * (color3 * 0.55) + waterColor * 0.75);
//}
color2 += wakesColor.rgb;

if(vWorldPosition.y <= 0.8) {
foamTexC.rgb *= 0.0;
color2 += foamTexC.rgb;
}
else
{

color2 += clamp(mix(vec3(0.0,0.0,0.0), foamTexC.rgb, vWorldPosition.y - 0.8), 0.0, 1.0);
}

color2 = hdr( color2, 0.45 );

float z = gl_FragCoord.z / gl_FragCoord.w;
//float fogFactor = exp( -0.2 * z );
//fogFactor = (fogEnd - z) / (fogEnd - fogStart);
float fogFactor = (fogEnd - z) / (fogEnd - fogStart);
//float fogFactor = exp2( -fogDensity * fogDensity * z * z * LOG2 );
fogFactor = clamp(fogFactor, fogClampLow, fogClampHigh);

float Scale = 0.6;
float shadow = 0.0 * (shadow2DProj(ShadowMap, gl_TexCoord[1]).r + shadow2DProj(ShadowMap2, ShadowTexCoord2).r);

if (z < myZ)
{
if (z < 38)
{
shadow =  shadow2DProj(ShadowMap, gl_TexCoord[1]).r;

float shadow1 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(-0.00025,0.00042,0.0,0.0)*Scale).r;
float shadow2 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.00030,-0.00021,0.0,0.0)*Scale).r;
float shadow3 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.00035,0.0004,0.0,0.0)*Scale).r;
float shadow4 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.00027,-0.00033,0.0,0.0)*Scale).r;

float shadow5 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(-0.00086,0.0001,0.0,0.0)*Scale).r;
float shadow6 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.00076,0.00024,0.0,0.0)*Scale).r;
float shadow7 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(-0.0002,0.00096,0.0,0.0)*Scale).r;
float shadow8 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(-0.00015,-0.00096,0.0,0.0)*Scale).r;

float shadow9 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(-0.000144,0.0002,0.0,0.0)*Scale).r;
float shadow10 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.000144,-0.0003,0.0,0.0)*Scale).r;
float shadow11 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.00014,0.000144,0.0,0.0)*Scale).r;
float shadow12 = shadow2DProj(ShadowMap, gl_TexCoord[1]+vec4(0.00023,-0.000144,0.0,0.0)*Scale).r;

shadow = shadow + shadow1 + shadow2 + shadow3 + shadow4;
shadow = shadow + shadow5 + shadow6 + shadow7 + shadow8;
shadow = shadow + shadow9 + shadow10 + shadow11 + shadow12;
shadow = shadow * 0.08;
}
else
{
shadow =  shadow2DProj(ShadowMap2, ShadowTexCoord2).r;

float shadow1 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(-0.00025,0.00042,0.0,0.0)*Scale).r;
float shadow2 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.00030,-0.00021,0.0,0.0)*Scale).r;
float shadow3 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.00035,0.0004,0.0,0.0)*Scale).r;
float shadow4 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.00027,-0.00033,0.0,0.0)*Scale).r;

float shadow5 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(-0.00086,0.0001,0.0,0.0)*Scale).r;
float shadow6 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.00076,0.00024,0.0,0.0)*Scale).r;
float shadow7 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(-0.0002,0.00096,0.0,0.0)*Scale).r;
float shadow8 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(-0.00015,-0.00096,0.0,0.0)*Scale).r;

float shadow9 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(-0.000144,0.0002,0.0,0.0)*Scale).r;
float shadow10 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.000144,-0.0003,0.0,0.0)*Scale).r;
float shadow11 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.00014,0.000144,0.0,0.0)*Scale).r;
float shadow12 = shadow2DProj(ShadowMap2, ShadowTexCoord2+vec4(0.00023,-0.000144,0.0,0.0)*Scale).r;

shadow = shadow + shadow1 + shadow2 + shadow3 + shadow4;
shadow = shadow + shadow5 + shadow6 + shadow7 + shadow8;
shadow = shadow + shadow9 + shadow10 + shadow11 + shadow12;
shadow = shadow * 0.08;
}
}
else
{
shadow = 1.0;
}

//if(vWorldPosition.y >= 0.9 && foamTexC.b > 0.2) {
	//gl_FragColor = mix(vec4(0.0,0.0,0.0,1.0) + sunStrength - 0.2, clamp(mix(vec4(color2, 1.0), vec4( foamTexC.rgb, 1.0), (vWorldPosition.y - 0.7) * 0.5), 0.0, 0.9), fogFactor) * sunStrength * vec4(mix(shadow, 1.0, 0.8));

gl_FragColor = mix(vec4(0.0,0.0,0.0,1.0) + sunStrength - 0.2, vec4(color2, 1.0), fogFactor) * sunStrength * vec4(mix(shadow, 1.0, 0.8));

//	} else { 
//	gl_FragColor = mix(vec4(0.0,0.0,0.0,1.0) + sunStrength - 0.2, vec4(color2, 1.0) * sunStrength, fogFactor) * vec4(mix(shadow, 1.0, 0.8));
//	}
}
