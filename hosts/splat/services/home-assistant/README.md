# Installing Home Assistant with Incus

Getting the preseed to load may require running `systemctl restart
incus-preseed.service` sometimes. Check the logs (`journalctl -u
incus-preseed.service`) and fix the state, then re-run the preseed. Conflicts
are usually resolved in favor of the existing resource.

## Import the image into Incus

Assuming that you're using local storage. First, you need to import the VM
image and give it appropriate metadata. Then you can create a VM.

```sh
tar czvf metadata.tar.gz metadata.yaml
sudo incus image import metadata.tar.gz haos_ova-18.2.qcow2 --alias haos
sudo incus create haos ha --vm -c security.secureboot=false -d root,size=40GiB -c limits.cpu=4 -c limits.memory=8GiB
```

## Configure devices

This repo is set up with a ZFS storage pool and macvlan.

```sh
sudo incus config device add ha sonoff-dongle usb vendorid=10c4 productid=ea60
sudo incus profile assign ha bridged
```

That should do it. Just start it up `sudo incus start ha`. Setup or restore from backup.
