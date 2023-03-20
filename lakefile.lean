import Lake
open Lake DSL


require Alloy from git "https://github.com/tydeu/lean4-alloy.git"@"334407"
require Cli from git "https://github.com/mhuisi/lean4-cli.git"@"nightly"
require Std from git "https://github.com/leanprover/std4"@"529a6"

package «sdl» {
  -- add package configuration options here
}

module_data alloy.c.o : BuildJob FilePath

lean_lib «Sdl» {
  -- add library configuration options here
  precompileModules := true
  nativeFacets := #[Module.oFacet, `alloy.c.o]
}


@[default_target]
lean_exe «sdl» {
  -- nativeFacets := #[Module.oFacet, `alloy.c.o]
  root := `Main
}

extern_lib «sdl2» (pkg : Package) := do
  let srcDir : FilePath := "/nix/store/i6wyx5q4xhzjkd2yh84iw5bhaqaml4r6-SDL2-2.24.2/lib/"
  let name : FilePath := "libSDL2.so"
  IO.FS.createDirAll pkg.libDir
  -- copy the static library from the nix path into the build path.
  -- this is necessary since lake then tries to build a dynlib next to the
  -- static lib, which does not work on nix as the nix store is read-only.
  -- More generally, we should maintain hygiene and copy the dependencies
  -- over.
  let tgtPath := (pkg.libDir / "libSDL2.a")
  IO.FS.writeBinFile tgtPath (← IO.FS.readBinFile (srcDir / name))
  pure (BuildJob.pure tgtPath)

--   -- let name := nameToStaticLib "sdl2"
--   -- let job ← fetch <| pkg.target ``importTarget

--   pure (BuildJob.pure "")

-- extern_lib «sdl-lib» (pkg : Package) := do 
--   let out ← captureProc { cmd := "sdl2-config", args := #["--static-libs"], cwd := pkg.dir }
  
--   let path := out
--   pure (BuildJob.pure path)
  -- buildStaticLib (pkg.libDir / name) #[job]

  -- buildO
  
  -- pure (BuildJob.pure path)
