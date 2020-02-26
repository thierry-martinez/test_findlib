let () =
  Findlib.init ();
  Fl_dynload.load_packages ~debug:true ["pcre"];
  Dynlink.loadfile "plugin/plugin.cmxs"
