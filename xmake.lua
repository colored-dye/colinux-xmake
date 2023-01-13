add_rules("mode.debug")
add_requires("llvm-mingw")
add_requires("myfltk")

target("dpp-example")
    add_rules("wdk.driver", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("dpp-example/sys/*.c")
    add_cflags("-m32", {force = true})
    add_ldflags("/entry:DriverEntry", {force = true})

target("loader")
    add_rules("wdk.binary", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("dpp-example/exe/*.c")
    add_cflags("-m32", {force = true})

target("llvm-mingw-test")
    add_deps("checksum") -- Depends on `checksum'
    set_kind("binary")
    set_toolchains("mingw@llvm-mingw")
    add_files("llvm-mingw-test/*.c")
    add_links("ntdll")
    add_rules("correct_checksum")

target("checksum")
    set_kind("binary")
    add_files("checksum/*.c")
    add_cflags("-m32", {force = true})

package("myfltk")
    add_deps("cmake")
    set_sourcedir(path.join(os.projectdir(), "console/fltk-1.3.8"))
    on_install(
        function (package) 
            local configs = {}
            table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
            table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
            import("package.tools.cmake").install(package, configs)
        end
    )

target("console")
    set_kind("binary")
    add_files("console/*.cpp")
    add_packages("myfltk")
    add_links("fltk")
    add_cflags("-m32", {force = true})

rule("correct_checksum")
    after_build(
        function (target)
            cprint("${bright green}Correct `%s''s checksum${clear}", target:targetfile())
            os.exec("%s/checksum %s", target:targetdir(), target:targetfile())
        end
    )
