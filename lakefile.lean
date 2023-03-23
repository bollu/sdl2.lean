import Lake
open Lake DSL


require Alloy from git "https://github.com/tydeu/lean4-alloy.git"@"334407"
require Cli from git "https://github.com/mhuisi/lean4-cli.git"@"nightly"
require Std from git "https://github.com/leanprover/std4"@"529a6"

elab "sdl2_ld_flags" : term => do
  let out ← IO.Process.output {cmd := "pkg-config", args := #["--libs", "SDL2"]}
  let term : Lean.Syntax.Term := Lean.quote <| List.toArray <|
    out.stdout.trim.split (· = ' ')
  Lean.Elab.Term.elabTerm term none


package «sdl» {
  moreLinkArgs := sdl2_ld_flags
  -- add package configuration options here
}

module_data alloy.c.o : BuildJob FilePath

lean_lib «Sdl» {
  precompileModules := true
}


@[default_target]
lean_exe «sdl» {
  moreLinkArgs := sdl2_ld_flags
  root := `Main
}


extern_lib «sdl-c-lib» (pkg : Package) := do
  -- build with cmake and make
  let sdlBaseDir : FilePath := pkg.dir / "SDL"
  let sdlBuildDir := sdlBaseDir / "build"
  IO.FS.createDirAll sdlBuildDir
  proc { cmd := "cmake", args := #["../", "-DCMAKE_POSITION_INDEPENDENT_CODE=ON", "-DSDL_STATIC=ON"], cwd := sdlBuildDir }
  proc { cmd := "cmake", args := #["--build", "."], cwd := sdlBuildDir }
  -- copy library
  let tgtPath := pkg.libDir / "libSDL3.a"
  IO.FS.createDirAll pkg.libDir
  IO.FS.writeBinFile tgtPath (← IO.FS.readBinFile (sdlBuildDir / "libSDL3.a"))
  -- give library to lake
  pure (BuildJob.pure tgtPath)

-- extern_lib «opengl-c-lib» (pkg : Package) := do

extern_lib «SDL-ffi» (pkg : Package) := do
  -- see also: https://github.com/yatima-inc/RustFFI.lean/blob/2a397cbc0904e2d575862c4067b512b6cc6b65f8/lakefile.lean
  let srcFileName := "SDLffi.c"
  let oFilePath := pkg.oleanDir / "libSDLffi.o"
  let srcJob ← inputFile srcFileName
  buildFileAfterDep oFilePath srcJob fun srcFile => do
    let flags := #["-I", (← getLeanIncludeDir).toString, 
                   "-I", (pkg.dir / "SDL" / "include").toString,
                   "-fPIC"] ++ sdl2_ld_flags
    compileO srcFileName oFilePath srcFile flags -- build static archive

extern_lib «GL-ffi» (pkg : Package) := do
  -- see also: https://github.com/yatima-inc/RustFFI.lean/blob/2a397cbc0904e2d575862c4067b512b6cc6b65f8/lakefile.lean
  let srcFileName := "GLffi.c"
  let oFilePath := pkg.oleanDir / "libGLffi.o"
  let srcJob ← inputFile srcFileName
  buildFileAfterDep oFilePath srcJob fun srcFile => do
    let flags := #[]
    compileO srcFileName oFilePath srcFile flags -- build static archive
