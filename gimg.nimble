# Package

version       = "1.3.0"
author        = "Thiago Navarro"
description   = "Google Images scraper lib"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gimg"]

binDir = "build"

# Dependencies

requires "nim >= 1.6.4"
requires "https://github.com/thisago/useragent"
