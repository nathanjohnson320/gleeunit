import gleam/list
import gleam/string
import gleam/dynamic.{Dynamic}
import gleam/io

pub fn discover_and_run_tests() -> Nil {
  let options = [
    Verbose,
    NoTty,
    Report(#(
      dangerously_convert_string_to_atom("gleeunit_progress"),
      [dynamic.from(#(dangerously_convert_string_to_atom("colored"), True))],
    )),
  ]

  find_files(matching: "**/*.{erl,gleam}", in: "test")
  |> list.map(remove_extension)
  |> list.map(dangerously_convert_string_to_atom)
  |> run_eunit(options)

  Nil
}

fn remove_extension(path: String) -> String {
  path
  |> string.replace(".gleam", "")
  |> string.replace(".erl", "")
  |> string.replace("/", "@")
}

external fn find_files(matching: String, in: String) -> List(String) =
  "gleeunit_ffi" "find_files"

external type Atom

external fn dangerously_convert_string_to_atom(String) -> Atom =
  "erlang" "binary_to_atom"

type EunitOption {
  Verbose
  NoTty
  Report(#(Atom, List(Dynamic)))
}

// NoTty
external fn run_eunit(List(Atom), List(EunitOption)) -> Dynamic =
  "eunit" "test"
