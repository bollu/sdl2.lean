#include <SDL3/SDL.h>
/*
 * FFI bindings to libSDL
 */

void SDLffi_init(int flags) { SDL_Init(flags); }

