import gleeunit
import gleeunit/should
import htmx/html

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn simple_a_tag_test() {
  html.a(
    href: "https://packetlost.dev",
    attrs: [#("id", "0")],
    body: html.text("Packet Lost & Found"),
  )
  |> html.done()
  |> should.equal(
    "<a href=\"https://packetlost.dev\" id=\"0\">Packet Lost & Found</a>",
  )
}

pub fn simple_nested_test() {
  {
    use <- html.body([])
    use <- html.div([#("id", "test")])
    use <- html.a("https://verticaltab.dev", [])
    html.raw("Vertical Tab")
  }
  |> html.done()
  |> should.equal(
    "<body><div id=\"test\"><a href=\"https://verticaltab.dev\">Vertical Tab</a></div></body>",
  )
}

pub fn simple_ul_li_test() {
  {
    use <- html.body([])
    use <- html.ul()
    html.elements([
      html.li(html.text("Noah")),
      html.li(html.text("Angela")),
      html.li(html.text("Freya")),
    ])
  }
  |> html.done()
  |> should.equal(
    "<body><ul><li>Noah</li><li>Angela</li><li>Freya</li></ul></body>",
  )
}
