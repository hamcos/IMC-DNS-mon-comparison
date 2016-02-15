#!/usr/bin/env bats

load common

@test "Check CSV output against dump" {
    run ../IMC-DNS-mon-comparison --input-json-file dump/dump.json --output-file last/dump.stdout
    echo $output
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
    run diff output-ok/dump.stdout last/dump.stdout
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "Check Monitoring LConf comparison" {
    run ../IMC-DNS-mon-comparison --input-file input/imc_export.csv --lconf-export-dir dump/lconf.export_test \
        --compare-with Mon \
        --output-json-file build/lconf_check.json --output-file last/lconf_check.csv
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
    diff output-ok/lconf_check.csv last/lconf_check.csv

    run type -a jq
    [ "$status" -eq 0 ] || skip "--output-json-file could not be tested because jq is not installed. Otherwise this test is passing."
    jq --sort-keys '.' build/lconf_check.json > last/lconf_check.json
    diff output-ok/lconf_check.json last/lconf_check.json
}

@test "Check DNS comparison" {
    echo "Might fail because it also queries for non-public entires."
    run ../IMC-DNS-mon-comparison --input-file input/imc_export_dns.csv \
        --compare-with DNS \
        --output-file last/dns_check.csv
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
    diff output-ok/dns_check.csv last/dns_check.csv
}
