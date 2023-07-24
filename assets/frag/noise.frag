#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 random2(vec2 st){

    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );

    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

float shape(vec2 st, float radius) {

	st = vec2(0.5)-st;

    float r = length(st)*2.0;
    float a = atan(st.y,st.x);
    float m = abs(mod(a+u_time*2.,3.14*2.)-3.14)/3.6;
    float f = radius;

    f += sin(a*8.)*noise(st+u_time*0.5)*.4;
    f += (sin(a*7.)*.1*pow(m,2.0));

    return 1.-smoothstep(f,f+0.01,r);
}

// shape-border:
float shapeBorder(vec2 st, float radius, float width) {
    return shape(st,radius);
}

void main() {

	vec2 st = gl_FragCoord.xy/u_resolution.xy;

    st -= vec2(0.5);

    float amount = (sin(u_time)* 0.5);

    st = scale( vec2(sin(u_time)+2.) ) * st;
    st = rotate2d( amount ) * st;

    st += vec2(0.5);

	vec3 color = vec3(1.0) * shapeBorder(st,0.5,0.02);

	gl_FragColor = vec4( 1.-color, 0.5 );
}
