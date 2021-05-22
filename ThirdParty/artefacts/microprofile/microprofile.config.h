#define MICROPROFILE_GPU_TIMERS_GL 1
#define MICROPROFILE_ENABLED 1
#define MICROPROFILE_GPU_TIMERS_MULTITHREADED 0


#ifdef MICROPROFILE_IMPL
#include "../renderer/qgl.h"
#define glGenQueries qglGenQueries
#define glDeleteQueries qglDeleteQueries
#define glQueryCounter qglQueryCounter
#define glGetInteger64v qglGetInteger64v
#define glGetQueryObjectui64v qglGetQueryObjectui64v
#endif
