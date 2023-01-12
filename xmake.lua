add_rules("mode.debug")
add_requires("llvm-mingw")

target("dpp-example")
    add_rules("wdk.driver", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("sys/*.c")

target("loader")
    add_rules("wdk.binary", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("exe/*.c")

target("llvm-mingw-test")
    add_deps("checksum")
    set_kind("binary")
    set_toolchains("mingw@llvm-mingw")
    add_files("llvm-mingw-test/*.c")
    add_links("ntdll")
    add_rules("correct_checksum")

target("checksum")
    set_kind("binary")
    add_files("checksum/*.c")

rule("correct_checksum")
    after_build(
        function (target)
            print("Correct `%s''s checksum", target:targetfile())
        end
    )
