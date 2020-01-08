import os

version     = "0.9.1"
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
    let gitExe: string = system.findExe("git")
    if gitExe == "":
        echo "Failed to find executable `git`."
        quit(1)

    let cmakeExe: string = system.findExe("cmake")
    if cmakeExe == "":
        echo "Failed to find executable `cmake`."
        quit(1)

    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    withDir projectDir():
        exec gitExe & " submodule update --init --recursive"

    withDir projectDir() / "RandomX" / "src":
        rmFile "configuration.h"
        rmFile "randomx.h"

        cpFile("../../MerosConfiguration/configuration.h", "./configuration.h")
        cpFile("../../MerosConfiguration/randomx.h", "./randomx.h")

    withDir projectDir() / "RandomX":
        mkDir "build"

    withDir projectDir() / "RandomX" / "build":
        exec cmakeExe & " -DARCH=native .."
        exec makeExe
