# Gimg

Google Images searcher

## Features

### Search

- [x] Specifications filtering
- [x] Filters (Tools)
  - [x] Size
  - [x] Color
  - [x] Type
  - [ ] Time
  - [ ] Usage Rights

### Data extracted

Here is an sample of returned object in json
```jsonc
{
  "specifications": [],
  "suggestedSpecifications": [
    {
      "name": "",
      "icon": ""
    }
  ],
  "images": [
    {
      "title": "",
      "thumbnail": {
        "src": "",
        "width": 0,
        "height": 0
      },
      "original": {
        "src": "", // Here is the original image url
        "width": 0,
        "height": 0
      },
      "site": "",
      "credit": "",
      "author": "",
      "copyright": "",
      "description": ""
    }
  ]
}
```

## TODO

- [ ] Add tests
- [ ] Improove readme

## License

MIT
