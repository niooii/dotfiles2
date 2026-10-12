// Vivid: livelier colours without blowing anything out.
// Smart vibrance (boosts muted colours more than already saturated ones, leaves greys alone),
// a gentle midtone contrast curve that keeps pure black and white fixed, and subtle split toning
// (cool lower midtones, warm upper midtones). Tweak the constants below, then `hyprshade on vivid` again.

#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float VIBRANCE = 0.35;   // 0.0 = unchanged
const float CONTRAST = 0.10;   // 0.0 = unchanged, keeps black and white fixed
const float SPLIT_TONE = 0.03; // 0.0 = off

const vec3 LUMA = vec3(0.2126, 0.7152, 0.0722);
const vec3 COOL = vec3(-0.6, 0.0, 1.0);
const vec3 WARM = vec3(1.0, 0.4, -0.8);

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 color = pixColor.rgb;

    float luma = dot(color, LUMA);
    float saturation = max(color.r, max(color.g, color.b)) - min(color.r, min(color.g, color.b));
    color = mix(vec3(luma), color, 1.0 + VIBRANCE * (1.0 - saturation));

    color = mix(color, smoothstep(0.0, 1.0, color), CONTRAST);

    luma = dot(color, LUMA);
    color += mix(COOL, WARM, luma) * SPLIT_TONE * 4.0 * luma * (1.0 - luma);

    fragColor = vec4(clamp(color, 0.0, 1.0), pixColor.a);
}
