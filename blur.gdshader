/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/pixelate

This shader is under CC0 license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform float amount: hint_range(16.0, 1024.0, 16.0);

void fragment()
{
	vec2 grid_uv = round(SCREEN_UV * float(amount)) / float(amount);
	
	vec4 text = texture(SCREEN_TEXTURE, grid_uv);
	float average = (text.r + text.g + text.b) / 3.0;	
	COLOR = vec4(text.r,text.g,text.b,1.0);
}