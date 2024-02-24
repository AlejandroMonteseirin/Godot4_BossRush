shader_type canvas_item;
uniform sampler2D LAVA_TEXTURE : source_color;
uniform sampler2D GROUND_TEXTURE : source_color;



void fragment() {
    // Obtén el color de los dos sprites
    vec4 ground_color = texture(GROUND_TEXTURE, UV);
    vec4 lava_color = texture(LAVA_TEXTURE, UV);

	//
	// Ajusta la coordenada Y con el offset

	// Ajusta la mezcla para dar más peso a la coordenada Y
    float blend_factor = pow(UV.y-9.5, 1.0);  // Puedes ajustar el exponente según tus necesidades

    //COLOR = vec4(UV.y-9.5, 0.0, 0.0, 1.0);

    // Mezcla ambos colores según la posición en Y (puedes ajustar esto según tus necesidades)
    COLOR = mix(lava_color,ground_color , UV.y-9.5);
}