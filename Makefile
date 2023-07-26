#
# This is the main GENIE/Reweight project Makefile.
# Machine specific flags and locations are read from 'make/Make.include'.
# Configuration options are read from 'make/Make.config' generated by the 'configure' script.
#
# Author: Costas Andreopoulos <costas.andreopoulos \at stfc.ac.uk>
#

SHELL = /bin/sh
NAME = all
MAKEFILE = Makefile

# Include machine specific flags and locations (inc. files & libs)
#
include $(GENIE_REWEIGHT)/src/make/Make.include

# define composite targets
#
BUILD_TARGETS =    print-make-info \
		   make-bin-lib-dir \
		   save-build-env \
		   autogenerated-headers \
			 prof2-spline \
		   reweight-framework \
		   reweight-io \
		   reweight-calculators \
		   general-apps \
		   install-scripts

INSTALL_TARGETS =  print-makeinstall-info \
		   check-previous-installation \
		   make-install-dirs \
		   copy-install-files

# define targets

all:     $(BUILD_TARGETS)
install: $(INSTALL_TARGETS)

print-make-info: FORCE
	@echo " "
	@echo " "
	@echo "***** Building GENIE/Reweight from source tree at: $(GENIE_REWEIGHT) [vrs: $(GENIE_REWEIGHT_VERSION)]"
	@echo "***** Building against: "
	@echo "*****   GENIE/Generator source tree at $(GENIE) [vrs $(GVERSION)]"
	@echo " "

make-bin-lib-dir: FORCE
	@echo " "
	@echo "** Creating GENIE/Reweight lib and bin directories..."
	cd ${GENIE_REWEIGHT} && \
	[ -d bin ] || mkdir bin && chmod 755 bin && \
	[ -d lib ] || mkdir lib && chmod 755 lib;

save-build-env: FORCE
	@echo " "
	@echo "** Taking a snapshot of the build environment..."
#	perl ${GENIE}/src/scripts/setup/genie-build-env-snapshot

autogenerated-headers: FORCE
	@echo " "
	@echo "** Adding automatically generated code..."
#	perl ${GENIE}/src/scripts/setup/genie-write-gbuild
#	perl ${GENIE}/src/scripts/setup/genie-write-gversion

reweight-framework: FORCE
	@echo " "
	@echo "** Building GENIE/Reweight framework..."
	cd ${GENIE_REWEIGHT}/src && \
	cd RwFramework && make && cd .. && \
	cd ${GENIE_REWEIGHT}

reweight-io: FORCE
	@echo " "
	@echo "** Building GENIE/Reweight IO utilities..."
	cd ${GENIE_REWEIGHT}/src && \
	cd RwIO && make && cd .. && \
	cd ${GENIE_REWEIGHT}

reweight-calculators: FORCE
	@echo " "
	@echo "** Building GENIE/Reweight calculators..."
	cd ${GENIE_REWEIGHT}/src && \
	cd RwCalculators && make && cd .. && \
	cd ${GENIE_REWEIGHT}

prof2-spline: FORCE
	@echo " "
	@echo "** Building GENIE/Reweight ProfSpline utilities..."
	cd ${GENIE_REWEIGHT}/src && \
	cd ProfSpline && make && cd .. && \
	cd ${GENIE_REWEIGHT}

general-apps : reweight-framework reweight-io reweight-calculators prof2-spline FORCE
	@echo " "
	@echo "** Apps..."
	cd ${GENIE_REWEIGHT}/src/Apps && \
	make && \
	cd ${GENIE_REWEIGHT}

install-scripts: FORCE
	@echo " "
	@echo "** Installing scripts..."
	cd ${GENIE_REWEIGHT}/src/scripts && \
	make install && \
	cd ${GENIE_REWEIGHT}

print-makeinstall-info: FORCE
	@echo " "
	@echo " "
	@echo "***** Installing GENIE/Reweight version $(GENIE_REWEIGHT_VERSION) at $(GENIE_REWEIGHT_INSTALLATION_PATH)"
	@echo " "

check-previous-installation: FORCE
	@echo " "
	@echo "** Testing for existing GENIE/Reweight installation at specified installation location..."
ifeq ($(strip $(GENIE_REWEIGHT_PREVIOUS_INSTALLATION)),YES)
	$(error Previous installation exists at your specified installation path: $(GENIE_REWEIGHT_INSTALLATION_PATH). Try 'make distclean' first)
endif

make-install-dirs: FORCE
	@echo " "
	@echo "** Creating directory structure for GENIE/Reweight installation..."
	[ -d ${GENIE_REWEIGHT_INSTALLATION_PATH} ] || mkdir ${GENIE_REWEIGHT_INSTALLATION_PATH}
	cd ${GENIE_REWEIGHT_INSTALLATION_PATH}
	[ -d ${GENIE_REWEIGHT_BIN_INSTALLATION_PATH} ] || mkdir ${GENIE_REWEIGHT_BIN_INSTALLATION_PATH}
	[ -d ${GENIE_REWEIGHT_LIB_INSTALLATION_PATH} ] || mkdir ${GENIE_REWEIGHT_LIB_INSTALLATION_PATH}
	[ -d ${GENIE_REWEIGHT_INC_INSTALLATION_PATH} ] || mkdir ${GENIE_REWEIGHT_INC_INSTALLATION_PATH}
	mkdir ${GENIE_REWEIGHT_INC_INSTALLATION_PATH}/RwFramework
	mkdir ${GENIE_REWEIGHT_INC_INSTALLATION_PATH}/RwIO
	mkdir ${GENIE_REWEIGHT_INC_INSTALLATION_PATH}/RwCalculators
	mkdir ${GENIE_REWEIGHT_INC_INSTALLATION_PATH}/ProfSpline

copy-install-files: FORCE
	@echo " "
	@echo "** Copying libraries/binaries/headers to installation location..."
	cp ${GENIE_REWEIGHT_BIN_PATH}/* ${GENIE_REWEIGHT_BIN_INSTALLATION_PATH} && \
	cd ${GENIE_REWEIGHT}/src && \
	cd RwFramework   &&    make install && cd .. && \
	cd RwIO          &&    make install && cd .. && \
	cd RwCalculators &&    make install && cd .. && \
	cd ProfSpline    &&    make install && \
	cd ${GENIE_REWEIGHT}

purge: FORCE
	@echo " "
	@echo "** Purging..."
	cd ${GENIE_REWEIGHT}/src && \
	cd RwFramework   &&    make purge && cd .. && \
	cd RwIO          &&    make purge && cd .. && \
	cd RwCalculators &&    make purge && cd .. && \
	cd ProfSpline    &&    make purge && cd .. && \
	cd Apps          &&    make purge && \
	cd ${GENIE_REWEIGHT}

clean: clean-files clean-dir clean-etc

clean-files: FORCE
	@echo " "
	@echo "** Cleaning..."
	cd ${GENIE_REWEIGHT}/src && \
	cd RwFramework   &&    make clean && cd .. && \
	cd RwIO          &&    make clean && cd .. && \
	cd RwCalculators &&    make clean && cd .. && \
	cd ProfSpline    &&    make clean && cd .. && \
	cd Apps          &&    make clean && cd .. && \
	cd scripts       &&    make clean && \
	cd $(GENIE_REWEIGHT)

clean-dir: FORCE
	@echo "Deleting GENIE/Reweight lib and bin directories..." && \
	cd $(GENIE_REWEIGHT) && \
	[ ! -d ./bin ] || rmdir ./bin && \
	[ ! -d ./lib ] || rmdir ./lib

clean-etc: FORCE
	cd $(GENIE_REWEIGHT) && \
	rm -f ./*log && \
	cd ${GENIE_REWEIGHT}

distclean: FORCE
	@echo " "
	@echo "** Cleaning GENIE/Reweight installation... "
	[ ! -d ${GENIE_REWEIGHT_INSTALLATION_PATH}/include/GENIE ] || rm -rf ${GENIE_REWEIGHT_INSTALLATION_PATH}/include/GENIE/
	cd ${GENIE_REWEIGHT}/src/ && \
	cd RwFramework   &&    make distclean && cd .. && \
	cd RwIO          &&    make distclean && cd .. && \
	cd RwCalculators &&    make distclean && cd .. && \
	cd ProfSpline    &&    make distclean && cd .. && \
	cd scripts       &&    make distclean && \
	cd ${GENIE_REWEIGHT}
FORCE:
