NAME       = sdsc-abinit-roll-test
VERSION    = 2
RELEASE    = 1
PKGROOT    = /root/rolltests

ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVER = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif

RPM.EXTRAS = AutoReq:No
RPM.FILES  = $(PKGROOT)/abinit.t
