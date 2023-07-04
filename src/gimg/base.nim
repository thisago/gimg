from std/uri import encodeQuery, parseUri, `$`
from std/strformat import fmt
from std/strutils import join, find
from std/sequtils import toSeq

import gimg/types

proc `$`*(s: ImageSize): string =
  result = "isz:"
  case s:
  of ImageSize.Any: result = ""
  of ImageSize.Large: result.add 'l'
  of ImageSize.Medium: result.add 'm'
  of ImageSize.Icon: result.add 'i'

proc getColor*(s: ImageColor; colorName = ""): string =
  var parsed: tuple[ic, isc: string]
  parsed.ic =
    case s:
    of ImageColor.Any: ""
    of ImageColor.Gray: "gray"
    of ImageColor.Transparent: "trans"
    of ImageColor.Specific: "specific"
  if s == ImageColor.Specific:
    parsed.isc = colorName

  var res: seq[string]
  if parsed.ic.len > 0:
    res.add fmt"ic:{parsed.ic}"
  if parsed.isc.len > 0:
    res.add fmt"isc:{parsed.isc}"

  result = res.join ","

proc `$`*(s: ImageType): string =
  result = "itp:"
  case s:
  of Imagetype.Any: result = ""
  of Imagetype.Clipart: result.add "clipart"
  of Imagetype.LineDrawing: result.add "lineart"
  of Imagetype.Gif: result.add "animated"

func buildUrl(
  search: string;
  specifications: openArray[string];
  size = ImageSize.Any;
  color = ColorSpec (ImageColor.Any, "");
  imageType = ImageType.Any;
  page = 1;
  language = "en-US"
): string =
  const chipsPrefix = "a"
  var chips = ""
  for specification in specifications:
    chips.add fmt"{chipsPrefix}:{specification},"

  let parsedColor = color.kind.getColor color.name

  var url = parseUri "https://www.google.com/search"
  url.query = encodeQuery({
    "tbm": "isch", # image search
    "q": search, # search query
    "chips": if chips.len > 0: chips[0..^2] else: chips, # specifications
    "hl": language, # language
    "tbs": [$size, $imageType, parsedColor].join ",", # filters (size, type, color)
    "start": $(20 * (page - 1))
  })
  result = $url

import std/asyncdispatch
from std/httpclient import newAsyncHttpClient, close, getContent, newHttpHeaders
from std/json import JsonNode, parseJson, items, `{}`, getStr, kind, JNull,
                               getInt, keys

proc getJsonData(html: string): JsonNode =
  const startStr = "AF_initDataCallback({key: 'ds:1', hash: '2', data:"
  var i = startStr.len + html.find startStr
  var json = html[i..^1]
  i = json.find ", sideChannel: {}});</script><script id=\""
  result = parseJson json[0..<i]

proc extractData(data: JsonNode): ImagesResult =
  new result
  for suggestedSpecification in data{1, 0, 0, 1}:
    var spec = SuggestedSpecification(
      name: suggestedSpecification{0}.getStr,
      icon: suggestedSpecification{1, 0}.getStr
    )
    result.suggestedSpecifications.add spec

  for data in data{56, 1, 0, 0, 1, 0}:
    let img = data{0, 0}{data{0, 0}.keys.toSeq[0]}{1}
    var image: ImageResult

    block desc:
      let descData = img{25}{"2003"}
      image.title = descData{3}.getStr
      image.site = descData{2}.getStr
      image.description = descData{3}.getStr
      try:
        let creditData = descData{18}
        image.credit = creditData{1, 0}.getStr
        image.author = descData{12}.getStr
        image.copyright = creditData{0}.getStr
      except:
        discard
    block thumb:
      let thumbData = img{2}
      image.thumbnail.src = thumbData{0}.getStr
      image.thumbnail.width = thumbData{1}.getInt
      image.thumbnail.height = thumbData{1}.getInt
    block original:
      let originalData = img{3}
      image.original.src = originalData{0}.getStr
      if image.original.src.len == 0:
        continue
      image.original.width = originalData{1}.getInt
      image.original.height = originalData{1}.getInt
    
    result.images.add image

from pkg/useragent import mozilla

proc searchImages*(
  search: string;
  specifications: seq[string] = @[];
  size = ImageSize.Any;
  color = ColorSpec (ImageColor.Any, "");
  imageType = ImageType.Any;
  page = 1;
  language = "en-US"
): Future[ImagesResult] {.async.} =
  ## Searches in Google Images, extract content and pack the data in object
  let client = newAsyncHttpClient(headers = newHttpHeaders({
    "User-Agent": mozilla
  }))
  result = extractData getJsonData await client.getContent buildUrl(search, specifications, size, color, imageType, page, language)

when isMainModule:
  from std/json import `$`, pretty
  import std/jsonutils

  # # discard
  # echo data.extractData.images[26].toJson.pretty

  echo buildUrl(
    search = "flower",
    specifications = [
      "red",
      "plant"
    ],
    color = (Specific, "pink"),
    imageType = Gif,
    page = 3
  )

  echo waitFor(searchImages("corn cake", @["cake"])).toJson.pretty
  # for img in waitFor(searchImages("ball")).images:
  #   echo img.thumbnail
  #   echo img.original
  #   echo "---------------"
