#!/usr/bin/env bats

@test "Check if the Perl-Script complies with perlcritic (as configured by ypid)" {
    echo "Tested against this configuration: https://github.com/ypid/dotfiles/blob/master/.perlcriticrc"
    run type -a perlcritic
    [ "$status" -eq 0 ] || skip "Skipped because perlcritic is not in your $PATH. Please install it."
    run perlcritic ../IMC-DNS-mon-comparison
    [ "$output" = "../IMC-DNS-mon-comparison source OK" ]
    [ "$status" -eq 0 ]
}
