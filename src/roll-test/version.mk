NAME       = sdsc-abinit-roll-test
VERSION    = 2
RELEASE    = 0
PKGROOT    = /home/jpg/cometscratch/abinit-roll/src/roll-test/test

ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVER = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif

RPM.EXTRAS = AutoReq:No
