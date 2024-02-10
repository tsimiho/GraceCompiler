open Ocamlbuild_plugin
 
let () =
  dispatch begin function
  | Before_hygiene -> tag_file "libminibasic.a" ["not_hygienic"]
  | _ -> ()
  end

