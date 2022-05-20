type
  ImageSize* {.pure.} = enum
    Any, Large, Medium, Icon

type
  ImageColor* {.pure.} = enum
    Any, Gray, Transparent, Specific
  ColorSpec* = tuple
    kind: ImageColor
    name: string

type
  ImageType* {.pure.} = enum
    Any, Clipart, LineDrawing, Gif

type
  ImagesResult* = ref object
    specifications*: seq[string]
    suggestedSpecifications*: seq[SuggestedSpecification]
    images*: seq[ImageResult]
  SuggestedSpecification* = object
    name*, icon*: string
  ImageResult* = object
    title*: string
    thumbnail*, original*: ImageImg
    site*: string
    credit*, author*, copyright*: string
    description*: string
  ImageImg* = object
    src*: string
    width*, height*: int
