import ../mc_randomx

var
    key: string = "Hash of a block whose height mod 2048 == 0.     "
    input: string = "Example input."

    flags: RandomXFlags = getFlags()
    cache: RandomXCache = allocCache(flags)
    vm: RandomXVM

cache.init(key)
vm = createVM(flags, cache, nil)

assert(vm.hash(input).len == 48)
assert(vm.hash(input) == vm.hash(input))

vm.destroy()
cache.dealloc()
