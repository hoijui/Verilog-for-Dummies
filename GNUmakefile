#   ----------------------------------------------------------------
#                           DEFINITIONS
#   ----------------------------------------------------------------

include *.configuration

#   make build system defines

HDL ?=                  verilog
STEP ?=                 rtl
MODE ?=                 batch

#   directory pathes

BACKENDDIR =            Backend
SIMULATIONDIR =         Simulation
SOURCESDIR =            Sources
TBENCHDIR =             TBench

#   tool variables

ECHO ?=                 @echo # -e
TAR ?=                  tar -zh
DATE :=                 $(shell date +%Y%m%d)

#   default

DISTRIBUTION =          ./GNUmakefile ./LICENSE $(PROJECT).* \
                        $(BACKENDDIR) \
                        $(SOURCESDIR) $(TBENCHDIR) \
                        $(SIMULATIONDIR)

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

#   display help screen if no target is specified

.PHONY: help
help:
	$(ECHO) "-------------------------------------------------------------------"
	$(ECHO) "    available targets:"
	$(ECHO) "-------------------------------------------------------------------"
	$(ECHO) ""
	$(ECHO) "    help       - print this help screen"
	$(ECHO) "    dist       - build a tarball with all important files"
	$(ECHO) "    clean-all  - clean up all intermediate files"
	$(ECHO) ""
	$(ECHO) "    <testcase> - run this specified test case (see list below)"
	$(ECHO) "    [MODE=batch|report|gui] <testcase>"
	$(ECHO) "               - run test in batch | report | gui mode (default: $(MODE))"
	$(ECHO) "    [STEP=rtl|pre|post] <testcase>"
	$(ECHO) "               - run test on rtl | pre-routed | post-routed (default: $(STEP))"
	$(ECHO) "    tests      - run all test cases (see list below)"
	$(ECHO) ""
	$(ECHO) "    netlist    - generate netlist"
	$(ECHO) "    par        - place and route"
	$(ECHO) "    export     - export delivery format"
	$(ECHO) "    all        - run all backend steps"
	$(ECHO) ""
	$(ECHO) "-------------------------------------------------------------------"
	$(ECHO) "    available testcases:"
	$(ECHO) "-------------------------------------------------------------------"
	$(ECHO) ""
	$(ECHO) "    $(TESTS)"
	$(ECHO) ""

#       make archiv by building a tarball with all important files

.PHONY: dist
dist: clean-all
	$(ECHO) "----    build a tarball with all important files    ----"
	$(TAR) -cvf $(PROJECT)_$(DATE).tgz $(DISTRIBUTION)

.PHONY: clean-all
clean-all:
	$(ECHO) "----    clean up all intermediate files    ----"
	$(MAKE) -C $(SIMULATIONDIR) -f simulation.mk clean
	$(MAKE) -C $(BACKENDDIR) -f backend.mk clean

#   ----------------------------------------------------------------
#                       BUILD MAIN TARGETS 
#   ----------------------------------------------------------------

.PHONY: tests
tests: $(TESTS) 

.PHONY: netlist
netlist:
	$(MAKE) -C $(BACKENDDIR) -f backend.mk $@

.PHONY: par
par: netlist
	$(MAKE) -C $(BACKENDDIR) -f backend.mk $@

.PHONY: export
export: par
	$(MAKE) -C $(BACKENDDIR) -f backend.mk $@

.PHONY: all
all: export

%:
	$(MAKE) -C $(SIMULATIONDIR) -f simulation.mk STEP=$(STEP) MODE=$(MODE) $@
