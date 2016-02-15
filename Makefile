.PHONY: test-main
test-main: test-pre
	cd test && bats main.bats

.PHONY: test
test: test-pre
	cd test && bats .



.PHONY: test-pre
test-pre:
	rm -rf test/last/

live: IMC-DNS-mon-comparison
	cp "$<" ..

.PHONY: docs
docs: IMC-DNS-mon-comparison-docs.html

IMC-DNS-mon-comparison-docs.html: IMC-DNS-mon-comparison
	pod2html "$<" --outfile "$@"

README.md: IMC-DNS-mon-comparison
	perl -MPod::Markdown -e 'Pod::Markdown->new->filter(@ARGV)' "$<" > "$@"
