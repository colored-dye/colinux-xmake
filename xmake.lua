add_rules("mode.debug")

target("dpp-example")
    add_rules("wdk.driver", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("sys/*.c")

target("loader")
    add_rules("wdk.binary", "wdk.env.wdm")
    set_values("wdk.env.winver", "win7")
    add_files("exe/*.c")
