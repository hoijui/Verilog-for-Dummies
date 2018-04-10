#   ----------------------------------------------------------------
#                       DEFINITIONS
#   ----------------------------------------------------------------

include ../../*.configuration

#   make build system defines

HDL ?=                  verilog
STEP ?=                 rtl
MODE ?=                 batch
TOP ?=                  ${TARGET}${SIZE}_${PACKAGE}

#   directory pathes

SOURCESDIR ?=           ../../Sources/${HDL}
LIBRARYDIR ?=           ../../Library/${HDL}
SOURCEFILES =           $(shell ls \
                            ${SOURCESDIR}/${PROJECT}_*.v \
                            ) #${LIBRARYDIR}/*.v)

#   backend directory names

NETLISTDIR =            ../netlist
PARDIR =                ../par
EXPORTDIR =             ../export

VPATH ?=                ${SOURCESDIR} ${LIBRARYDIR}

#   tool variables

ECHO ?=                 @echo # -e
RM ?=                   /bin/rm -f

#   cool stuff

SYN =                   yosys
SYN_OPTIONS =           -p

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

.PHONY: clean
clean:
	-$(RM) *.blif

#   ----------------------------------------------------------------
#                       BACKEND TARGETS
#   ----------------------------------------------------------------

.SUFFIXES: .v .blif

.v.blif: ${SOURCEFILES}
	${SYN} ${SYN_OPTIONS} "synth_ice40 -blif $@" $< ${SOURCEFILES}

.PHONY: netlist
netlist: ${TOP}.blif
