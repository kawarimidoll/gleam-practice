import gleam/bytes_builder
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/io

import mist.{type Connection, type ResponseData}

pub fn main() {
  let assert Ok(_) =
    fn(_req: Request(Connection)) -> Response(ResponseData) {
      response.new(200)
      |> response.set_body(
        "hello mist!" |> bytes_builder.from_string |> mist.Bytes,
      )
      |> response.set_header("content-type", "text/plain")
    }
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}
