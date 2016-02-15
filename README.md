IMC-DNS-mon-comparison - Compare a CSV report from IMC against Monitoring and DNS.

# DESCRIPTION

The script reads a CSV list exported by IMC and checks if the hosts do exist in the Monitoring system (on which this script is intended to run) and if the hostname resolves to the IPv4 address contained in the IMC CSV. It also checks if the IPv4 address has a reverse record pointing to its FQDN.

The check if a host is monitored is currently implemented by checking against an LConf configuration export on the master.
Adding a second check using MK Livestatus can be implemented but the check against LConf export was preferred to allow to test this script using Bats.

Any deviations will be reported by the script in CSV format.

# SYNOPSIS

IMC-DNS-mon-comparison \[arguments\]

# USAGE

./IMC-DNS-mon-comparison --input-file test/input/imc\_export.csv

# OPTIONS

- -v|--verbose

    Verbose mode. This may be supplied multiple times to get more and more information.

- -d|--debug

    Debug mode. This may be supplied multiple times to get more and more information.

- -i|--input-file

    Required. Specifies the IMC report CSV file.

- -I|--input-file-encoding

    The scripts try to guess the encoding. If that fails, you will have to provide the encoding.

- -o|--output-file

    If given, write the report to this file. If not given, write it to STDOUT.

- -J|--input-json-file

    Reads the data structure of the given JSON file into the %hosts and skip the population of the %hosts hash in this script.
    Useful for testing.

- -j|--output-json-file

    Writes the internal data structure of %hosts into the given file path using JSON.
    Useful for testing.

- -D|--lconf-export-dir

    Directory path of LConf to use for checking if the entry is referenced.

    Defaults to `/var/LConf/lconf.export`.

- -c|--compare-with

    Against which dataset should the input data be compared with. Options are:

        DNS
        Mon

    Datasets which are not considered will be reported as OK in the CSV --output-file. In the --output-json-file, they will be not contained as the check has not been executed.

    Defaults to: DNS,Mon

- -h|--help

    Print help page.

- -V|--version

    Print IMC-DNS-mon-comparison version.

# REQUIRED ARGUMENTS

Which arguments are required depends on in which output mode the script is running.

By default only the --output-ldif-file argument is required.

# DEPENDENCIES

Required modules:

    File::Find
    List::MoreUtils

    File::Slurp
    Encode
    Encode::Guess

    Text::CSV
    JSON

    Net::DNS
    Net::IP

On Debian those dependencies are packaged. Just install them:

**libnet-dns-perl libnet-ip-perl libtext-csv-perl libtext-csv-xs-perl**

CPAN:

    cpan File::Find List::MoreUtils File::Slurp Encode Encode::Guess Text::CSV JSON Net::DNS Net::IP

# CONFIGURATION

None.

# DIAGNOSTICS

Useful options for diagnostics:

    --debug
    --input-json-file
    --output-json-file

Also, spin up the test framework which uses Bats.

# EXIT STATUS

0   No errors occurred and no deviations could be found.

1   No errors occurred but there where deviations.

2   Any other error which which caused the script to die.

# BUGS AND LIMITATIONS

None that I know of. Submit patches if you find bugs :)

# INCOMPATIBILITIES

None that I am aware of.

# AUTHOR

Robin Schneider &lt;robin.schneider@hamcos.de>

# LICENSE AND COPYRIGHT

Copyright (C) 2015 Robin Schneider &lt;robin.schneider@hamcos.de>

hamcos IT Service GmbH http://www.hamcos.de

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, version 3 of the
License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see &lt;https://www.gnu.org/licenses/>.

# SUBROUTINES

- read\_input\_csv\_file()

    Read CSV file exported by IMC and return the information contained as hash reference.

- check\_against\_dns()

    Check the hosts given as $hosts\_ref against the systems DNS server and store the result in the given %{$hosts\_ref}.

- check\_dns\_a\_record()

    Check the DNS mapping from $hostname to $ipv4 address and store the result in the given %{$hosts\_ref}.

- check\_dns\_ptr\_record()

    Check the DNS mapping from $ipv4 address to $hostname and store the result in the given %{$hosts\_ref}.

- check\_against\_nagios\_lconf()

    Check if the hosts given as %{$hosts\_ref} are contained in the last Icinga configuration export and store the result in %{$hosts\_ref}.

- get\_not\_ok\_csv()

    Return a string containing all hosts with one or more non-OK check fields, encoded as CSV.
