#   ----------------------------------------------------------------
#                       DEFINITIONS
#   ----------------------------------------------------------------

include ../*.configuration

#   make build system defines

HDL ?=                  verilog
STEP ?=                 rtl
MODE ?=                 batch
TOP ?=                  $(TARGET)$(SIZE)_$(PACKAGE)

#   directory pathes

BACKENDDIR =            ../Backend
LIBRARYDIR =            ../Library
SOURCESDIR =            ../Sources

#   backend directory names

NETLISTDIR =            netlist
PARDIR =                par
EXPORTDIR =             export

#   tool variables

ECHO ?=                 @echo # -e
RM ?=                   /bin/rm -f

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

.PHONY: clean
clean:
	$(MAKE) -C $(NETLISTDIR) -f netlist.mk $@
	$(MAKE) -C $(PARDIR) -f par.mk $@
	$(MAKE) -C $(EXPORTDIR) -f export.mk $@

#   ----------------------------------------------------------------
#                       RUN BACKEND
#   ----------------------------------------------------------------

.PHONY: netlist
netlist:
	$(MAKE) -C $(NETLISTDIR) -f netlist.mk TOP=$(TOP) $@

.PHONY: par
par:
	$(MAKE) -C $(PARDIR) -f par.mk TOP=$(TOP) $@

.PHONY: export
export:
	$(MAKE) -C $(EXPORTDIR) -f export.mk TOP=$(TOP) $@
