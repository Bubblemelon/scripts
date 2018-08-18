# Using QEMU KVM for Red Hat CoreOS

- [Running a Red Hat CoreOS Virtual Machine](#running-a-rhcos-vm)
    - [Details on the `qemu-kvm` options used](#detail-qemu-kvm-options)
- [Contents of `key.ign`](#contents-of-keyign)
- [Logging into the Red Hat CoreOS VM](#login-rhcos-vm)
- [More information on `qemu-kvm`]()

## [Running a Red Hat CoreOS Virtual Machine](#running-a-rhcos-vm)
Run this command to get the a qemu-kvm virtual machine for Red Hat CoreOS instance running:

```
$ qemu-kvm -m 2048M -accel kvm -smp cores=4 -fw_cfg \
name=opt/com.coreos/config,file=key.ign -drive file=rhcos.qcow2.qemu \
-net nic,model=virtio -net user,hostfwd=tcp::2222-:22
```
<br/>

### [Details on the `qemu-kvm` options used](#detail-qemu-kvm-options):

`-m` Sets guest startup RAM size to megs megabytes. Default is 128 MiB.  Optionally, a suffix of "M" or "G" can be used to signify a value in megabytes or gigabytes respectively. `2048M` is equivalent to `2G`. Note: set size `-m 8G` to run openshift. 

`-accel` Enables a `kvm` accelerator. `tcg` is the default.

`-smp` Specifies symmetric multiprocessing of four cores.

`-fw_cfg` Creates a firmware configuration entry named `opt/com.coreos/config` with the contents from `key.ign`. See this [qemu fw_cfg doc](https://github.com/qemu/qemu/blob/master/docs/specs/fw_cfg.txt). 

`-drive` Creates a new drive and is a shortcut to defining `-blockdev` and `device` options. `-drive file=` defines the image `rhcos.qcow2.qemu` which is in the qcow2 format to use with this drive. Run `qemu-img info rhcos.qcow2.qemu` for more information on this file.

`-net nic,...` Defines a paravirtualized network adapter via `model=virtio`. Specify `-net nic,model=help` for a list of available devices for the target vm. 

`-net user,` Redirects TCP or UDP connections from host to guest, in this case with TCP `hostfwd=tcp::2222-:22`.

`-M` The machine type e.g Standard PC, ISA-only PC, or Intel-Mac was not specified in this command, so it will default to `pc-0.12`. Use `qemu-kvm -M ?` to display a list of valid parameters.

<br/>

## [Contents of `key.ign`](#contents-of-keyign)

This is sepcific to Operating Systems that run Ignition in the initramfs e.g. Container Linux, Fedora CoreOS and Red Hat CoreOS.

`key.ign` is an [ignition](https://coreos.com/ignition/docs/latest/what-is-ignition.html) config in json format, that will be used by the vm only at *first boot*. Changes made to this config after the first boot will not affect the VM. You will need a clean file of `rhcos.qcow2.qemu` to have the config take effect. 

```
{
    "ignition": {
        "version": "2.2.0"
    },
    "passwd": {
        "users": [
            {
                "name": "core",
                "sshAuthorizedKeys": [
                    "ssh-rsa ...public key contents...
                ]
            }
        ]
    }
}
```
Replace the contents of `sshAuthorizedKeys` with the contents of a public key, generated via ssh-keygen. 

[Validate the ignition config](https://coreos.com/validate/) before putting it to use. See some [examples of igntion configs here](https://coreos.com/ignition/docs/latest/what-is-ignition.html).

## [Logging into the Red Hat CoreOS VM](#login-rhcos-vm)
You'll not be able to find the IP of this instance via `arp -an` or `netsat -l` nor will you find it on `virsh net-list`.

Given that this option `-net user,hostfwd=tcp::2222-:22` was used to run the VM. Run the following command to ssh into it:

`$ ssh core@127.0.0.1`
Replace `core` with whatever name set in the `"name: "..."` line of the ignition config. 

You may want to specify the corresponding private key to `ssh` in:

`$ ssh -i ~/.ssh/somekey_rsa core@127.0.0.1`

Save this trouble by running `eval "$(ssh-agent -s)"` and then adding it the agent by running `$ ssh-add ~/.ssh/somekey_rsa`.

### [Troubleshooting](#troubleshooting)

If this error occurs,

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the RSA key sent by the remote host is
...
Please contact your system administrator.
Add correct host key in /home/hostname /.ssh/known_hosts to get rid of this message.
Offending RSA key in ....
RSA host key for pong has changed and you have requested strict checking.
Host key verification failed.
```

then run the following:

```
$ ssh -o StrictHostKeyChecking=false -o UserKnownHostsFile=/dev/null core@127.0.0.1 
```
Or delete the line in `~/.ssh/known_hosts` with the `127.0.0.1` IP and then try running `ssh core@127.0.0.1` again. 

----
TALK ABOUT ss -ltpn 
----
