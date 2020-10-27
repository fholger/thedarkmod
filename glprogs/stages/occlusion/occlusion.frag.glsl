#version 430 core

layout (early_fragment_tests) in;
layout (std430, binding = 0) writeonly buffer VisibilityBuffer {
    int visible[];
};

flat in int entityIndex;

out vec4 FragColor;

void main() {
    visible[entityIndex] = 1;
    FragColor = vec4(0, 0, 0, 1);
}
