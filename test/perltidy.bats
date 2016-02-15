#!/usr/bin/env bats

load common

@test "Check if the Perl-Script is formated as perltidy suggests it (as configured by ypid)" {
    echo "Prettify using this configuration: https://github.com/ypid/dotfiles/blob/master/.perltidyrc"
    run type -a perltidy
    [ "$status" -eq 0 ] || skip "Skipped because perltidy is not in your $PATH. Please install it."
    run perltidy ../IMC-DNS-mon-comparison --outfile ./build/IMC-DNS-mon-comparison
    [ "$status" -eq 0 ]
    [ "$output" = "" ] || [ "$output" = "Ignoring -b; you may not use -b and -o together" ]
    diff ../IMC-DNS-mon-comparison ./build/IMC-DNS-mon-comparison
}
