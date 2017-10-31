#
# Makefile for ipt_NETFLOW.ko
#

.PHONY: all version distclean clean

ifneq ($(KERNELRELEASE),)

obj-m = ipt_NETFLOW.o
ccflags-y = -DENABLE_MAC -DENABLE_VLAN -DENABLE_DIRECTION -DHAVE_LLIST

EXTRA_CFLAGS += -I$(M) -I$(KDIR)

else

PWD					:= $(shell pwd)
KERNELDIR			?= /lib/modules/$(shell uname -r)/build
SUBDIRS				:= $(PWD)
VERSION_FILE		:= version.h
VERSION				:= $(shell git describe --tag | sed -e 's/-g/-/')
SAVED_VERSION		:= \
	$(shell sed -e 's/.*"\(.*\)".*/\1/p;d' $(VERSION_FILE) 2> /dev/null)

all: version
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

.PHONY: $(if $(filter $(VERSION),$(SAVED_VERSION)),,$(VERSION_FILE))

version: $(VERSION_FILE)

$(VERSION_FILE):
	@echo "#ifndef __VERSION_H__"				>  $(VERSION_FILE)
	@echo "#define __VERSION_H__"				>> $(VERSION_FILE)
	@echo "#define GITVERSION \""$(VERSION)"\"" >> $(VERSION_FILE)
	@echo "#endif /* __VERSION_H__ */"			>> $(VERSION_FILE)

distclean: clean

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean

endif
