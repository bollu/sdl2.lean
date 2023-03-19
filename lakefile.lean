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
