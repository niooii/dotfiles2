// Comfort: calmer colours for reading everywhere.
// Mutes saturation, narrows the brightness range (softer white, slightly lifted black)
// and warms the image a little. Tweak the constants below, then `hyprshade on comfort` again.

#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float SATURATION = 0.80; // 1.0 = unchanged, 0.0 = greyscale
const float WHITE = 0.88;      // what pure white becomes (1.0 = unchanged)
const float BLACK = 0.05;      // what pure black becomes (0.0 = unchanged)
const float WARMTH = 0.07;     // how much to cut blue (and a bit of green) by, 0.0 = neutral

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 color = pixColor.rgb;

    float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(luma), color, SATURATION);

    color = mix(vec3(BLACK), vec3(WHITE), color);

    color *= vec3(1.0, 1.0 - WARMTH * 0.3, 1.0 - WARMTH);

    fragColor = vec4(clamp(color, 0.0, 1.0), pixColor.a);
}
