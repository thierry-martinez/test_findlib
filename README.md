# Test findlib with PPX

This repository exhibits a problem I have while using findlib's dynamic loading facilities inside a PPX.

A module `Plugin` is defined in the directory `plugin/`, which relies on the library `pcre`.
The dynamic library `plugin/plugin.cmxs` can be built with `dune build plugin/plugin.cmxs`.

There is no problem when `plugin/plugin.cmxs` is loaded by a simple executable, such as the one defined in `test_direct/`. The code of `test_direct` is fairly simple.

```ocaml
let () =
  Findlib.init ();
  Fl_dynload.load_packages ~debug:true ["pcre"];
  Dynlink.loadfile "plugin/plugin.cmxs"
```

By building `dune build test_direct/test_direct.exe`, one can check that executing `test_direct/test_direct.exe` in the directory `_build/default` succeeds without error (it is important to execute the program with `_build/default` as current directory, in order to let the program find `plugin/plugin.cmxs`). The debugging log is reproduced below. In particular, we can notice that `pcre.cmxs` is loaded.

```
[DEBUG] Fl_dynload: about to load: unix
[DEBUG] Fl_dynload: files="unix.cmxs"
[DEBUG] Fl_dynload: loading "unix.cmxs"
[DEBUG] Fl_dynload: about to load: threads.posix
[DEBUG] Fl_dynload: files=""
[DEBUG] Fl_dynload: about to load: threads
[DEBUG] Fl_dynload: files=""
[DEBUG] Fl_dynload: about to load: pcre
[DEBUG] Fl_dynload: files="pcre.cmxs"
[DEBUG] Fl_dynload: loading "pcre.cmxs"
```

By contrast, if the same code as in `test_direct` is executed inside a PPX, `pcre.cmxs` is not loaded and, therefore, loading `plugin.cmxs` fails. One can check this by trying to compile `dune build test_ppx/test_ppx.exe`, which invokes the PPX transformer defined in `ppx/`. The latter just wraps the test above in an `Ast_mapper.mapper`. The log is reproduced below, where it appears that `pcre.cmxs` does not seem to be loaded.

```                                                             
[DEBUG] Fl_dynload: about to load: pcre
[DEBUG] Fl_dynload: files=""
Fatal error: exception Dynlink.Error (Dynlink.Cannot_open_dll "Dynlink.Error (Dynlink.Cannot_open_dll \"Failure(\\\"/home/tmartine/tmp/test_findlib/_build/default/plugin/plugin.cmxs: undefined symbol: camlPcre__exec_583\\\")\")")  
```
