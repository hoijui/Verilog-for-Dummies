#   ----------------------------------------------------------------
#                       DEFINITIONS
#   ----------------------------------------------------------------

include ../*.configuration

#   make build system defines

HDL ?=                  verilog
STEP ?=                 rtl
MODE ?=                 batch

#   directory pathes

LIBRARYDIR =            Library
SIMULATIONDIR =         Simulation
SOURCESDIR =            Sources
TBENCHDIR =             TBench

#   tool variables

SIMULATOR1 ?=           iverilog -g2 # -Wall
SIMULATOR2 ?=           vvp # -v
INCLUDEDIRS ?=          -I../$(LIBRARYDIR)/$(HDL) -I../$(SOURCESDIR)/$(HDL)
SIMSRCDIRS ?=           -y../$(SOURCESDIR)/$(HDL)
SIMTBDIRS ?=            -y../$(TBENCHDIR)/$(HDL)
WAVEVIEWER ?=           gtkwave

ECHO ?=                 @echo # -e
RM ?=                   /bin/rm -f

#       other stuff

DUMPPATH ?=             ../$(SIMULATIONDIR)/$(STEP)

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

.PHONY: clean
clean:
	-$(RM) ../$(SIMULATIONDIR)/*/*.vcd
	-$(RM) ../$(SIMULATIONDIR)/*/*.vpp

#   ----------------------------------------------------------------
#                       RUN TESTCASES
#   ----------------------------------------------------------------

%:      PROJECT_DEFINES += -DDUMPFILE=\"$(DUMPPATH)/$@.vcd\" -DTALKATIVE $(INCLUDEDIRS)
%:      ../$(TBENCHDIR)/$(HDL)/%.v
	$(SIMULATOR1) $(PROJECT_DEFINES) $(SIMSRCDIRS) $(SIMTBDIRS) -o ../$(SIMULATIONDIR)/$(STEP)/$@.vpp $<
	$(ECHO) "----    Run Test: $@    ----"
	$(SIMULATOR2) ../$(SIMULATIONDIR)/$(STEP)/$@.vpp
ifeq ($(MODE), gui)
	$(WAVEVIEWER) -f $(DUMPPATH)/$@.vcd -a ../$(SIMULATIONDIR)/$(STEP)/$@.do
endif

