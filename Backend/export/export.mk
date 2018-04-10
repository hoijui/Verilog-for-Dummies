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

CONSTRAINTDIR =         ../../Sources/pcf

#   backend directory names

NETLISTDIR =            ../netlist
PARDIR =                ../par
EXPORTDIR =             ../export

VPATH ?=                ${PARDIR}

#   tool variables

ECHO ?=                 @echo # -e
RM ?=                   /bin/rm -f

#   cool stuff

EXPORTER =              icepack
EXPORTER_OPTIONS =

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

.PHONY: clean
clean:
	-$(RM) *.bin

#   ----------------------------------------------------------------
#                       BACKEND TARGETS
#   ----------------------------------------------------------------

.SUFFIXES: .asc .bin

.asc.bin:
	${EXPORTER} ${EXPORTER_OPTIONS} $< $@

.PHONY: export
export: ${TOP}.bin
