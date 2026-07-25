shader_type canvas_item;

uniform int color_levels : hint_range(2, 256) = 32;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3; 

vec3 quantize_color(vec3 color, int levels) {
    float quantizer = float(levels - 1);
    return floor(color * quantizer + 0.5) / quantizer;
}

float dither(vec2 position, float brightness) {
    int x = int(mod(position.x, 4.0));
    int y = int(mod(position.y, 4.0));
    int index = x + y * 4;
    float dithering[16] = float[](
        0.0, 0.5, 0.125, 0.625,
        0.75, 0.25, 0.875, 0.375,
        0.1875, 0.6875, 0.0625, 0.5625,
        0.9375, 0.4375, 1.0, 0.8125
    );
    float threshold = dithering[index];
    return brightness < threshold ? 0.0 : 1.0;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 final_color = tex_color.rgb;
    
    final_color = quantize_color(final_color, color_levels);
    
    float brightness = dot(final_color, vec3(0.3, 0.59, 0.11));
    brightness += dither_strength * (dither(FRAGCOORD.xy, brightness) - 0.5);
    final_color *= (1.0 + dither_strength * (dither(FRAGCOORD.xy, brightness) - 0.5));
    
    COLOR = vec4(final_color, tex_color.a);
}