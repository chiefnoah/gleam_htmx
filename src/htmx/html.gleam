import gleam/dict.{type Dict}
import gleam/string_builder.{type StringBuilder}

pub type Attrs =
  List(#(String, String))

pub fn div(attributes: Attrs, body: fn() -> StringBuilder) -> StringBuilder {
  tag("div")(
    attributes
      |> dict.from_list(),
    body,
  )
}

pub fn a(
  href href: String,
  attrs attrs: Attrs,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  attrs
  |> dict.from_list()
  |> dict.insert("href", href)
  |> tag("a")(body)
}

pub fn p(
  attrs attrs: Attrs,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  attrs
  |> dict.from_list()
  |> tag("p")(body)
}

pub fn html(
  lang lang: String,
  attrs attrs: Attrs,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  attrs
  |> dict.from_list()
  |> dict.insert("lang", lang)
  |> tag("html")(body)
}

/// Equivalent to a `<head>` tag enclosing a body. Attributes are not allowed.
pub fn head(
  attrs attrs: Attrs,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  tag("head")(
    attrs
      |> dict.from_list(),
    body,
  )
}

pub fn body(
  attrs attrs: Attrs,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  tag("body")(
    attrs
      |> dict.from_list(),
    body,
  )
}

pub fn emptybody() -> StringBuilder {
  string_builder.new()
}

pub fn text(c: String) -> fn() -> StringBuilder {
  fn() { string_builder.from_string(c) }
}

pub fn raw(c: String) -> StringBuilder {
  string_builder.from_string(c)
}

pub fn ul(body body: fn() -> StringBuilder) -> StringBuilder {
  tag("ul")(dict.new(), body)
}

pub fn li(body body: fn() -> StringBuilder) -> StringBuilder {
  tag("li")(dict.new(), body)
}

pub fn script(
  src src: String,
  attrs attrs: Attrs,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  tag("script")(
    attrs
      |> dict.from_list()
      |> dict.insert("src", src),
    body,
  )
}

/// `elements` joins multiple elements together at the same nesting level.
/// Example:
/// ```
/// use <- html.ul()
/// html.elements([
///   html.li(html.text("A")),
///   html.li(html.text("B")),
///   html.li(html.text("C"))
/// ])
/// |> html.done()
/// // => "<ul><li>A</li><li>B</li><li>C</li><ul>
/// ```
pub fn elements(e: List(StringBuilder)) -> StringBuilder {
  string_builder.join(e, "")
}

pub fn append(
  builder builder: StringBuilder,
  body body: fn() -> StringBuilder,
) -> StringBuilder {
  string_builder.append_builder(builder, body())
}

/// `tag` returns a function that takes in a `Dict` of attributes and a `body`
/// callback and returns a `StringBuilder` containing the HTML representation
/// of that tag and it's enclosing body, recursively evaluated.
pub fn tag(
  name: String,
) -> fn(Dict(String, String), fn() -> StringBuilder) -> StringBuilder {
  fn(attributes: Dict(String, String), body: fn() -> StringBuilder) {
    string_builder.new()
    |> string_builder.append("<")
    |> string_builder.append(name)
    |> dict.fold(over: attributes, with: fn(builder, key, value) {
      builder
      |> string_builder.append(" ")
      |> string_builder.append(key)
      |> string_builder.append("=\"")
      |> string_builder.append(value)
      |> string_builder.append("\"")
    })
    |> string_builder.append(">")
    |> string_builder.append_builder(body())
    |> string_builder.append("</")
    |> string_builder.append(name)
    |> string_builder.append(">")
  }
}

pub fn done(b: StringBuilder) -> String {
  string_builder.to_string(b)
}
