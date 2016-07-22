.PHONY: all

CONFIG_DRIVES :=				\
	ipv6-vm-1-ds.iso			\
	ipv6-vm-2-ds.iso			\
	ipv6-vm-3-ds.iso

IMAGE_DIR := /var/lib/libvirt/images

all: install

config: $(CONFIG_DRIVES)

%.iso: user-data meta-data create-config-drive Makefile
	@echo generating $@
	@./create-config-drive -h $(patsubst %-ds.iso,%,$@) -k ~/.ssh/id_rsa.pub -u user-data $@

install: $(patsubst %,$(IMAGE_DIR)/%,$(CONFIG_DRIVES))

$(IMAGE_DIR)/%.iso: %.iso
	sudo cp $< $@

clean:
	$(RM) $(CONFIG_DRIVES)

redo-net: remove-net
	virsh net-define juju6.xml
	virsh net-start juju6

remove-net:
	-virsh net-undefine juju6
	-virsh net-destroy juju6
