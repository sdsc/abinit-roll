PACKAGE     = abinit
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 2
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

MKLVERSION=mkl
ifneq ("$(ROLLOPTS)", "$(subst mkl=,,$(ROLLOPTS))")
  MKLVERSION = $(subst mkl=,,$(filter mkl=%,$(ROLLOPTS)))
endif

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
RPM.PREFIX  = $(PKGROOT)
