#!/bin/bash

for i in "$@"; do
    virsh pool-refresh default
    name=ipv6-vm-${i}
    virsh destroy $name || true
    virsh undefine $name || true
    virsh pool-refresh default
    virsh vol-delete --pool default ${name}.img
done
