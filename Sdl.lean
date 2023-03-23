namespace Sdl

def INIT_EVERYTHING : UInt64 :=  0

@[extern "SDLffi_Init"]
opaque init (arg : UInt64) : BaseIO Unit

structure Window where
 private mk : UInt64 
deriving Inhabited

@[extern "SDLffi_create_window"]
opaque CreateWindow (arg : UInt64) : BaseIO Unit

structure GLContext where
  private mk : UInt64 
deriving Inhabited

@[extern "SDLffi_GL_CreateContext"]
opaque GL_CreateContext (window : Window) : BaseIO GLContext

@[extern "SDLffi_GL_SwapWindow"]
opaque GL_SwapWindow  (w : Window) : BaseIO Unit

structure Event where 
deriving Inhabited

@[extern "SDLffi_PollEvent"]
opaque SDL_PollEvent (w : Window) : BaseIO (Option Event)

@[extern "glffi_glViewport"]
opaque glViewport (x y w h : UInt64) : BaseIO Unit

@[extern "SDLffi_GL_DeleteContext"]
opaque GL_DeleteContext (ctx : GLContext) : BaseIO Unit

@[extern "SDLffi_GL_SetSwapInterval"]
opaque GL_SetSwapInterval (interval : UInt64) : BaseIO Unit

@[extern "SDLffi_GL_SetAttributeDoubleBuffer"]
opaque GL_SetAttributeDoubleBuffer : BaseIO Unit 

end Sdl
