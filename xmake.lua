add_rules("mode.debug")
add_requires("llvm-mingw")

target("dpp-example")
    add_rules("wdk.driver", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("dpp-example/sys/*.c")
    add_cflags("-m32", {force = true})

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

rule("correct_checksum")
    after_build(
        function (target)
            cprint("${bright green}Correct `%s''s checksum${clear}", target:targetfile())
            os.exec("%s/checksum %s", target:targetdir(), target:targetfile())
        end
    )

target("hello")
	set_kind("binary")
	add_files("hello/*.c")

