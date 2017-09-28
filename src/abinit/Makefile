
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.6 (Emerald Boa)
# 		         version 6.1 (Emerald Boa)
# 
# Copyright (c) 2000 - 2013 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@
#
# $Log$ 
REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

COMPILER_FLAGS = -O2 -fPIC
COMPILERTYPE=gf
ifeq ("$(COMPILERNAME)", "intel")
  COMPILERTYPE=intel
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILERTYPE=intel
endif

CUDABUILD = no
CUDAOPTS=

ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDAOPTS = --enable-gpu --with-gpu-flavor=cuda-double --with-gpu-prefix=$${CUDAHOME}
  CUDABUILD = yes
endif

MODULE_LOAD_ABINIT_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_ABINIT_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

MODULE_LOAD_ABINIT_MKL = $(call MODULE_LOAD_PACKAGE, $(MKLVERSION), MKLHOME)
DESCRIBE_ABINIT_MKL = echo built with mkl $(call GET_MODULE_VERSION, $(MKLVERSION))
  

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
          $(DESCRIBE_NETCDF); \
          $(DESCRIBE_ABINIT_MKL); \
	  if test "$(CUDABUILD)" = "yes"; then \
	    $(DESCRIBE_ABINIT_CUDA); \
	  fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo GPLv3  > $@

CACHE_DIR=$(REDHAT.ROOT)/cache

build: $(SRC_DIRS)
	/bin/mkdir -p .abinit/tarballs
	/bin/cp *gz .abinit/tarballs/
	patch $(MAGMA_DIR)/Makefile patch-files/Makefile.patch
	patch $(MAGMA_DIR)/make.inc-examples/make.inc.mkl-icc patch-files/make.inc.mkl-icc.patch
	patch $(SOURCE_DIR)/configure patch-files/configure.patch
	( \
          $(MODULE_LOAD_CC); \
          $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_NETCDF); \
          $(MODULE_LOAD_ABINIT_MKL); \
          export CFLAGS="$(COMPILER_FLAGS)"; \
          export CXXFLAGS="$(COMPILER_FLAGS)"; \
          export FCFLAGS="$(COMPILER_FLAGS)"; \
          export CC=$(CC); \
          export CXX=$(CXX); \
          export FC=$(FC); \
          export MKLLIB=`find $${MKLHOME}/lib/* -maxdepth 0 | head -1`; \
 	  cd $(SOURCE_DIR); \
 	  ./configure --enable-mpi  --enable-mpi_io --with-mpi-prefix=$${MPIHOME} --prefix=$(CACHE_DIR) --with-dft-flavor=atompaw+libxc+bigdft+wannier90 --with-netcdf-incs=-I$${NETCDFHOME}/include --with-netcdf-libs="-L$${NETCDFHOME}/lib -lnetcdff -lnetcdf" --with-linalg-flavor=mkl --with-linalg-libs="-L$${MKLLIB} -lmkl_$(COMPILERTYPE)_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl" --enable-fallbacks --with-trio-flavor=netcdf --enable-atompaw=yes --enable-bigdft=yes --enable-etsf-io=yes --enable-libxc=yes --enable-linalg=yes --enable-netcdf=yes --enable-wannier90=yes; \
 	  make -j 16; \
 	  make install; \
 	  if test "$(CUDABUILD)" = "yes"; then \
 	      cd ..; \
 	      $(MODULE_LOAD_ABINIT_CUDA); \
 	      export CUDADIR=$${CUDAHOME}; \
 	      cp $(MAGMA_DIR)/make.inc-examples/make.inc.mkl-$(CC) $(MAGMA_DIR)/make.inc; \
 	      cd $(MAGMA_DIR); \
 	      make -j 16 install prefix=$(CACHE_DIR); \
 	      cd ../$(SOURCE_DIR); \
 	      make distclean; \
 	      export LD_LIBRARY_PATH=$(CACHE_DIR)/lib:/usr/lib64/nvidia:$${LD_LIBRARY_PATH}; \
              if test -e "/usr/lib64/nvidia"; then \
                    export LDFLAGS=-L/usr/lib64/nvidia; \
                    export LIBS=-lnvidia-fatbinaryloader; \
              fi; \
              ./configure --enable-mpi  --enable-mpi_io --with-mpi-prefix=$${MPIHOME} $(CUDAOPTS) --prefix=$(CACHE_DIR) --with-dft-flavor=atompaw+libxc+bigdft+wannier90 --with-netcdf-incs=-I$${NETCDFHOME}/include --with-netcdf-libs="-L$${NETCDFHOME}/lib -lnetcdff -lnetcdf" --with-linalg-flavor=mkl+magma --with-linalg-libs="-L$${MKLLIB} -L$(CACHE_DIR)/lib -lmkl_$(COMPILERTYPE)_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl -lmagma" --enable-fallbacks --with-trio-flavor=netcdf --enable-atompaw=yes --enable-bigdft=yes --enable-etsf-io=yes --enable-libxc=yes --enable-linalg=yes --enable-netcdf=yes --enable-wannier90=yes; \
              make -j 16 ; \
              cp src/98_main/abinit $(CACHE_DIR)/bin/abinit.cuda; \
          fi \
        )
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	cp -r $(CACHE_DIR)/* $(ROOT)/$(PKGROOT); \
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) $(BIGDFT_DIR) _arch DESCRIPTION LICENSE .abinit
