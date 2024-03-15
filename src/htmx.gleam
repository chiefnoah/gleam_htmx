import gleam/string_builder.{type StringBuilder}
import htmx/html
import gleam/http/response.{type Response}
import gleam/http/request.{type Request}
import gleam/http/elli
import gleam/bytes_builder.{type BytesBuilder}
import gleam/io

fn htmx_dep() -> StringBuilder {
    html.script("https://unpkg.com/htmx.org@1.9.10", [], html.emptybody)
}

fn home_template() -> StringBuilder {
  use <- html.html("en", [])
  {
    // <head>
    use <- html.head([])
    htmx_dep()
  }
  |> html.append(fn() {
    use <- html.body([])
    html.p([], html.text("Hello, world"))
  })

}

fn service(req: Request(t)) -> Response(BytesBuilder) {
  io.debug(req)
  let body =
    home_template()
    |> bytes_builder.from_string_builder()
  response.new(200)
  |> response.prepend_header("Made-with", "Gleam")
  |> response.set_body(body)
}

pub fn main() {
  elli.become(service, on_port: 3000)
}
