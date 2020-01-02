layout (std140, binding = 7) uniform PROJ {
    mat4 viewMatrix;
    mat4 inverseViewMatrix;
    mat4 projectionMatrix;
    mat4 viewProjectionMatrix;
};
