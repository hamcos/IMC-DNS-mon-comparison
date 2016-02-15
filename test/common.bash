
setup() {
    mkdir -p build last
}

teardown() {
    ## Cleanup last in Makefile to allow to copy last to output-ok/
    rm -rf build
}
