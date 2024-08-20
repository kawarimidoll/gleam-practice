import gleam/dynamic
import gleam/io
import gleam/json.{array, int, null, object, string}

import jasper.{Index, Key, Root, String, parse_json, query_json}

// import ../../../LilyRose2798/jasper

pub type Idol {
  Idol(name: String, age: Int, favorites: Favorites)
}

pub type Favorites {
  Favorites(hobby: String, food: String)
}

pub fn main() {
  io.println("Hello from hello_json!")
  io.println("------")
  io.println("use gleam_json:")
  sample_gleam_json()
  io.println("------")
  io.println("use jasper")
  sample_jasper()
}

fn sample_jasper() {
  let assert Ok(json) = parse_json("{ \"foo\": [1, true, \"hi\"] }")
  io.debug(json)
  let assert Ok(String(str)) = query_json(json, Root |> Key("foo") |> Index(2))
  io.println(str)
}

fn sample_gleam_json() {
  let encoded =
    object([
      #("name", string("arisu")),
      #("age", int(12)),
      #(
        "favorites",
        object([#("food", string("strawberry")), #("hobby", string("game"))]),
      ),
    ])

  io.debug(encoded)
  io.println(json.to_string(encoded))

  let decoded =
    json.decode(
      // JSONテキストデータ
      json.to_string(encoded),
      dynamic.decode3(
        Idol,
        dynamic.field(named: "name", of: dynamic.string),
        dynamic.field(named: "age", of: dynamic.int),
        dynamic.field(
          // 再帰的なフィールドはfieldの引数にfieldを指定
          named: "favorites",
          of: dynamic.decode2(
            Favorites,
            dynamic.field(named: "hobby", of: dynamic.string),
            dynamic.field(named: "food", of: dynamic.string),
          ),
        ),
      ),
    )
  io.debug(decoded)
}
