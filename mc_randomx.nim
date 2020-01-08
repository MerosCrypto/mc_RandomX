#Get the current folder.
const currentFolder: string = currentSourcePath().substr(0, currentSourcePath().len - 15)

#Include the RandomX headers.
{.passC: "-I" & currentFolder & "RandomX/src/".}

#Link against RandomX.
{.passL: "-L" & currentFolder & "RandomX/build/".}
{.passL: "-lrandomx".}

#Link against the C++ standard lib, as required by RandomX.
{.passL: "-lstdc++".}

#Various types.
type
    RandomXFlags* {.importc: "randomx_flags", header: "randomx.h".} = enum
        RANDOMX_FLAG_DEFAULT      = 0
        RANDOMX_FLAG_LARGE_PAGES  = 1
        RANDOMX_FLAG_HARD_AES     = 2
        RANDOMX_FLAG_FULL_MEM     = 4
        RANDOMX_FLAG_JIT          = 8
        RANDOMX_FLAG_SECURE       = 16
        RANDOMX_FLAG_ARGON2_SSSE3 = 32
        RANDOMX_FLAG_ARGON2_AVX2  = 64
        RANDOMX_FLAG_ARGON2       = 96

    RandomXCacheObject {.importc: "randomx_cache", header: "randomx.h".} = object
    RandomXCache* = ptr RandomXCacheObject

    RandomXDatasetObject {.importc: "randomx_dataset", header: "randomx.h".} = object
    RandomXDataset* = ptr RandomXDatasetObject

    RandomXVMObject {.importc: "randomx_vm", header: "randomx.h".} = object
    RandomXVM* = ptr RandomXVMObject

#Get the recommended flags.
proc getFlags*(): RandomXFlags {.importc: "randomx_get_flags", header: "randomx.h".}

#Allocate a cache.
proc allocCache*(
    flags: RandomXFlags
): RandomXCache {.importc: "randomx_alloc_cache", header: "randomx.h".}

#Initiate a cache.
proc init(
    cache: RandomXCache,
    key: pointer,
    keyLen: csize
) {.importc: "randomx_init_cache", header: "randomx.h".}

proc init*(
    cache: RandomXCache,
    key: var string
) {.inline.} =
    cache.init(cast[pointer](addr key[0]), csize(key.len))

#Deallocate a cache.
proc dealloc*(
    cache: RandomXCache
) {.importc: "randomx_release_cache", header: "randomx.h".}

#Allocate a dataset.
proc allocDataset*(
    flags: RandomXFlags
): RandomXDataset {.importc: "randomx_alloc_dataset", header: "randomx.h".}

#Initiate a dataset.
proc init*(
    dataset: RandomXDataset,
    cache: RandomXCache,
    startItem: culong,
    itemCount: culong
) {.importc: "randomx_init_dataset", header: "randomx.h".}

#Deallocate a dataset.
proc dealloc*(
    dataset: RandomXDataset
) {.importc: "randomx_release_dataset", header: "randomx.h".}

#Create a VM.
proc createVM*(
    flags: RandomXFlags,
    cache: RandomXCache,
    dataset: RandomXDataset
): RandomXVM {.importc: "randomx_create_vm", header: "randomx.h".}

#Set the VM's cache.
proc setCache*(
    vm: RandomXVM,
    cache: RandomXCache
) {.importc: "randomx_vm_set_cache", header: "randomx.h".}

#Set the VM's dataset.
proc setDataset*(
    vm: RandomXVM,
    dataset: RandomXDataset
) {.importc: "randomx_vm_set_dataset", header: "randomx.h".}

#Destroy a VM.
proc destroy*(
    vm: RandomXVM
) {.importc: "randomx_destroy_vm", header: "randomx.h".}

#Hash data.
proc hash(
    vm: RandomXVM,
    input: pointer,
    inputLen: csize,
    output: pointer
) {.importc: "randomx_calculate_hash", header: "randomx.h".}

proc hash*(
    vm: RandomXVM,
    input: var string
): string =
    result = newString(48)
    vm.hash(cast[pointer](addr input[0]), csize(input.len), cast[pointer](addr result[0]))

#Hash data yet optimized for when there's a series of hashes.
proc hashFirst*(
    vm: RandomXVM,
    input: pointer,
    inputLen: csize
) {.importc: "randomx_calculate_hash_first", header: "randomx.h".}

proc hashNext*(
    vm: RandomXVM,
    input: pointer,
    inputLen: csize,
    output: pointer
) {.importc: "randomx_calculate_hash_next", header: "randomx.h".}
