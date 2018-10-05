ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif

COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif

MKLVERSION=mkl
ifneq ("$(ROLLOPTS)", "$(subst mkl=,,$(ROLLOPTS))")
  MKLVERSION = $(subst mkl=,,$(filter mkl=%,$(ROLLOPTS)))
endif



PKGROOT        = /opt/abinit
NAME           = sdsc-abinit
VERSION        = 8.8.4
RELEASE        = 0

SRC_SUBDIR     = abinit

SOURCE_NAME    = abinit
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 8.8.4
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_NAME)-$(SOURCE_VERSION)

LIBXC_NAME    = libxc
LIBXC_SUFFIX  = tar.gz
LIBXC_VERSION = 3.0.0
LIBXC_PKG     = $(LIBXC_NAME)-$(LIBXC_VERSION).$(LIBXC_SUFFIX)
LIBXC_DIR     = $(LIBXC_PKG:%.$(LIBXC_SUFFIX)=%)

ATOMPAW_NAME    = atompaw
ATOMPAW_SUFFIX  = tar.gz
ATOMPAW_VERSION = 4.1.0.4
ATOMPAW_PKG     = $(ATOMPAW_NAME)-$(ATOMPAW_VERSION).$(ATOMPAW_SUFFIX)
ATOMPAW_DIR     = $(ATOMPAW_PKG:%.$(ATOMPAW_SUFFIX)=%)

WANNIER90_NAME    = wannier90
WANNIER90_SUFFIX  = tar.gz
WANNIER90_VERSION = 2.0.1.1
WANNIER90_PKG     = $(WANNIER90_NAME)-$(WANNIER90_VERSION).$(WANNIER90_SUFFIX)
WANNIER90_DIR     = $(WANNIER90_NAME)-$(WANNIER90_VERSION)

MAGMA_NAME    = magma
MAGMA_SUFFIX  = tar.gz
MAGMA_VERSION = 2.4.0
MAGMA_PKG     = $(MAGMA_NAME)-$(MAGMA_VERSION).$(MAGMA_SUFFIX)
MAGMA_DIR     = $(MAGMA_NAME)-$(MAGMA_VERSION)

BIGDFT_NAME     = bigdft
BIGDFT_SUFFIX   = tar.gz
BIGDFT_VERSION  = 1.7.1.25
BIGDFT_PKG      = $(BIGDFT_NAME)-$(BIGDFT_VERSION).$(BIGDFT_SUFFIX)
BIGDFT_DIR      = $(BIGDFT_NAME)-suite


ETSF_IO_NAME    = etsf_io
ETSF_IO_SUFFIX  = tar.gz
ETSF_IO_VERSION = 1.0.4
ETSF_IO_PKG     = $(ETSF_IO_NAME)-$(ETSF_IO_VERSION).$(ETSF_IO_SUFFIX)
ETSF_IO_DIR     = $(ETSF_IO_PKG:%.$(ETSF_IO_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(LIBXC_PKG) $(ATOMPAW_PKG) $(ETSF_IO_PKG) $(WANNIER90_PKG) $(MAGMA_PKG) $(BIGDFT_PKG)

RPM.EXTRAS     = AutoReq:No
RPM.PREFIX     = $(PKGROOT)
