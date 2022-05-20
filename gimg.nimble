# Package

version       = "1.2.2"
author        = "Luciano Lorenzo"
description   = "Google Images scraper lib and CLI"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gimg"]

binDir = "build"

# Dependencies

requires "nim >= 1.6.4"
requires "useragent"
