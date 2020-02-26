(lang dune 1.11)

(package
 (name test_findlib)
 (synopsis "test_findlib")
 (description "test_findlib")
 (depends
  (ocaml (and (>= 4.03.0) (< 4.11.0)))
  (ocaml-migrate-parsetree (>= 1.5.0))
  (dune (>= 1.11.0))))
