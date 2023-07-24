#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;

// multipe types of random:

float random (in float x) {
    return fract(sin(x)*1e4);
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(10.0,25.0)))* 35000.12345);
}

float randomSerie(float x, float freq, float t) {
    return step(.8,random( floor(x*freq)-floor(t) ));
}

// can I make the same pattern¿?

void main()
{   
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    st.x *= iResolution.x/iResolution.y;

    vec3 color = vec3(0.0);

    float cols = 5.;
    float freq = random(floor(iTime))+abs(atan(iTime)*0.01);
    float t = 60.+iTime*(1.0-freq)*30.;

    freq += random(floor(st.y));
    
    // change color and patterns:

    float offset = 0.01;
    
    color = vec3(randomSerie(st.y, freq*50., t+offset),
                 randomSerie(st.y, freq*50., t),
                 randomSerie(st.y, freq*50., t-offset));

    gl_FragColor = vec4(1.0-color,0.1);
}