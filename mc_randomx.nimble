import os

version     = "0.9.6"
author      = "Luke Parker"
description = "A Nim wrapper for RandomX with the configuration used by the Meros Cryptocurrency."
license     = "MIT"

requires "nim >= 1.0.4"

installDirs = @[
    "RandomX"
]

installFiles = @[
    "mc_randomx.nim"
]

before install:
    let cmakeExe: string = system.findExe("cmake")
    if cmakeExe == "":
        echo "Failed to find executable `cmake`."
        quit(1)

    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    withDir thisDir() / "RandomX" / "src":
        rmFile "configuration.h"
        cpFile("../../MerosConfiguration/configuration.h", "./configuration.h")

    withDir thisDir() / "RandomX":
        mkDir "build"

    withDir thisDir() / "RandomX" / "build":
        exec cmakeExe & " .."
        exec makeExe
