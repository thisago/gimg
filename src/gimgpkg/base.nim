#[

https://www.google.com/search?tbm=isch&hl=en-US&q=flower&chips=t:red,t:plant
https://www.google.com/search?tbm=isch&hl=en-US&q=flower&chips=t:pink

]#

from std/uri import encodeQuery, parseUri, `$`
from std/strformat import fmt

type ImageSize* {.pure.} = enum
  Any = "X",
  Large = "l", Medium = "X", Icon = "i"

proc `$`*(s: ImageSize): string =
  result = "isz:"
  case s:
  of Icon: result.add 'i'

func buildUrl(
  search: string;
  specifications: openArray[string];
  size = ImageSize.Any;
  language = "en-US"
): string =
  const chipsPrefix = "a"
  var chips = ""
  for specification in specifications:
    chips.add fmt"{chipsPrefix}:{specification},"

  var url = parseUri "https://www.google.com/search"
  url.query = encodeQuery({
    "tbm": "isch",
    "q": search,
    "chips": chips[0..^2],
    "hl": language,
    "tbs=isz:l"
  })
  result = $url

when isMainModule:
  echo buildUrl(
    search = "flower",
    specifications = [
      "red",
      "plant"
    ]
  )
