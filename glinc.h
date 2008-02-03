// SDL_opengl.h interferes with glew.h, so don't include either directly, just use this header file
#define NO_SDL_GLEXT
#include <GL/glew.h>
#include "SDL_opengl.h"
