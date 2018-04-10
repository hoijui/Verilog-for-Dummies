#   ----------------------------------------------------------------
#                       DEFINITIONS
#   ----------------------------------------------------------------

include ../../*.configuration

#   make build system defines

HDL ?=                  verilog
STEP ?=                 rtl
MODE ?=                 batch
TOP ?=                  $(TARGET)$(SIZE)_$(PACKAGE)

#   directory pathes

CONSTRAINTDIR ?=        ../../Sources/pcf
CONSTRAINTS =           ${CONSTRAINTDIR}/${TOP}.pcf

#   backend directory names

NETLISTDIR =            ../netlist
PARDIR =                ../par
EXPORTRDIR =            ../export

VPATH ?=                ${NETLISTDIR}

#   tool variables

ECHO ?=                 @echo # -e
RM ?=                   /bin/rm -f

#   cool stuff

PAR =                   arachne-pnr
PAR_OPTIONS =           -d $(SIZE) -P $(PACKAGE)

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

.PHONY: clean
clean:
	-$(RM) *.asc

#   ----------------------------------------------------------------
#                       BACKEND TARGETS
#   ----------------------------------------------------------------

.SUFFIXES: .blif .asc

.blif.asc: ${CONSTRAINTS}
	${PAR} ${PAR_OPTIONS} -p ${CONSTRAINTS} -o $@ $<

.PHONY: par
par: ${TOP}.asc
