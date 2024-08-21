import gleam/io

import gleam/fetch
import gleam/http/request
// import gleam/http/response
import gleam/javascript/promise

const url = "http://www.example.com"

pub fn main() {
  io.println("URL: " <> url)
  use resp <- promise.try_await(get_fetch(url))

  resp.status |> io.debug

  resp.body |> io.debug

  // necessary for type consistency
  promise.resolve(Ok(Nil))
}

fn get_fetch(url: String) {
  let assert Ok(req) = request.to(url)
  use resp <- promise.try_await(fetch.send(req))
  fetch.read_text_body(resp)
}
