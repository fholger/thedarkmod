#version 450 core

layout (early_fragment_tests) in;
layout (location = 0) out vec4 color;

void main() {
    color = vec4(0, 0, 0, 1);
}
