add_rules("mode.debug")
-- add_requires("llvm-mingw")
add_requires("fltk 1.4.0", {
    arch = "x86",
    configs = {
        toolchains = "msvc",
        debug = true,
        shared = false,
        vs_runtime = "MTd",
    }
})

target("dpp-example")
    add_rules("wdk.driver", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("dpp-example/sys/*.c")
    add_cflags("-m32", {force = true})
    add_ldflags("/entry:DriverEntry", {force = true})
    set_toolchains("clang-cl")
    -- add_defines("DEBUG")

target("loader")
    add_rules("wdk.binary", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("dpp-example/exe/*.c")
    add_cflags("-m32", {force = true})
    set_toolchains("clang-cl")

target("console")
    set_kind("binary")
    add_files("console/*.cpp")
    set_toolchains("clang-cl")
    add_packages("fltk")
    add_cxxflags("-m32", {force = true})

includes("colinux")

-- target("llvm-mingw-test")
--     add_deps("checksum") -- Depends on `checksum'
--     set_kind("binary")
--     set_toolchains("mingw@llvm-mingw")
--     add_files("llvm-mingw-test/*.c")
--     add_links("ntdll")
--     add_rules("correct_checksum")

-- target("checksum")
--     set_kind("binary")
--     add_files("checksum/*.c")
--     set_toolchains("msvc")

-- rule("correct_checksum")
--     after_build(
--         function (target)
--             cprint("${bright green}Correct `%s''s checksum${clear}", target:targetfile())
--             os.exec("%s/checksum %s", target:targetdir(), target:targetfile())
--     end)

-- package("myfltk")
--     set_description("Local fltk static x86 library")
--     -- add_deps("cmake")
--     set_sourcedir(path.join(os.projectdir(), "console", "fltk-1.3.8", "ide", "VisualC2010", "fltk.sln"))

--     add_cflags("-m32", {force = true})
--     on_install(
--         function (package) 
--             local configs = {}
--             -- table.insert(configs, "vs_runtime = MT")
--             import("package.tools.msbuild").build(package)
--     end)

