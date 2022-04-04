# Package

version       = "1.1.0"
author        = "Luciano Lorenzo"
description   = "Google Images scraper lib and CLI"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gimg"]

binDir = "build"

# Dependencies

requires "nim >= 1.7.1"
requires "useragent"
