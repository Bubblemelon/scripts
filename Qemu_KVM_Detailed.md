
# [Using QEMU KVM](#using-qemu-kvm)

- [Installation](#installation)
- [Qemu Overview](#qemu-overview)
- [The Qemu VM Instance](#qemu-vm-instance)
    - [Details on the `qemu-kvm` options used](#qemu-kvm-cmd-details)
- [Qemu Resources](#qemu-resources)
    - [Qemu Binaries Explained](#qemu-bin-explain)
- [Logging into a QEMU VM](#login-to-qemu-kvm)
- [Managing a QEMU VM](#managing-a-qemu-vm)
    - [The QEMU Console](#the-qemu-console)
    - [Shutdown and Starting up the Same Instance](#shutdown-Startup)
    - [Saving the State of a VM](#save-state)
---
## [Installation](#installation)

KVM requires a CPU with virtualization extensions, found on most consumer CPUs. These extensions are called Intel VT or AMD-V. Command to check for CPU support: 

```bash
egrep '^flags.*(vmx|svm)' /proc/cpuinfo
```

**Optional**: 

Install [Virtualization packages](https://docs.fedoraproject.org/quick-docs/en-US/getting-started-with-virtualization.html); this includes Libvirt tools.
```bash
sudo dnf install @virtualization
```

## [Qemu Overview](#qemu-overview)

Virtual machines created with `qemu-kvm` are not visible for libvirt-based tools, meaning if `virt-manager` was launched, the VM will not show up on this interface. 

Virtualization stack simplified:
```
------- Vagrant
----- Libvirt e.g. virsh + virt-manager
---- Qemu e.g. qemu-kvm
--- KVM i.e. Kernel Based Virtual Machine
```
This is simply because Qemu cannot communicate up the virtualization stack. [OpenSuse KVM Cookbook is a great resource](https://www.suse.com/documentation/opensuse121/pdfdoc/book_kvm/book_kvm.pdf). Communication can only go down the stack.

## [The Qemu VM Instance](#qemu-vm-instance)

Run this command to get the a qemu-kvm virtual machine for Red Hat CoreOS instance running:

```
$ qemu-kvm -m 2048M -accel kvm -smp cores=4 -fw_cfg \
name=opt/com.coreos/config,file=key.ign -drive file=rhcos.qcow2.qemu \
-net nic,model=virtio -net user,hostfwd=tcp::2222-:22
```
<br/>

### [Details on the `qemu-kvm` options used](#qemu-kvm-cmd-details):

`-m` Sets guest startup RAM size to megs megabytes. Default is 128 MiB.  Optionally, a suffix of "M" or "G" can be used to signify a value in megabytes or gigabytes respectively. `2048M` is equivalent to `2G`.

`-accel` Enables a `kvm` accelerator. `tcg` is the default.

`-smp` Specifies symmetric multiprocessing of four cores.

`-fw_cfg` Creates a firmware configuration entry named `opt/com.coreos/config` with the contents from `key.ign`. See this [qemu fw_cfg doc](https://github.com/qemu/qemu/blob/master/docs/specs/fw_cfg.txt). 

`-drive` Creates a new drive and is a shortcut to defining `-blockdev` and `device` options. `-drive file=` defines the image `rhcos.qcow2.qemu` which is in the qcow2 format to use with this drive. Run `qemu-img info rhcos.qcow2.qemu` for more information on this file.

`-net nic,...` Defines a paravirtualized network adapter via `model=virtio`. Specify `-net nic,model=help` for a list of available devices for the target vm. 

`-net user,` Redirects TCP or UDP connections from host to guest, in this case with TCP `hostfwd=tcp::2222-:22`.

`-M` The machine type e.g Standard PC, ISA-only PC, or Intel-Mac was not specified in this command, so it will default to `pc-0.12`. Use `qemu-kvm -M ?` to display a list of valid parameters.

<br/>

## [Qemu Resources](#qemu-resources)

For more information on the general command structure to start a qemu vm, see page 94 titled [Basic Installation with qemu-kvm](https://www.suse.com/documentation/opensuse121/pdfdoc/book_kvm/book_kvm.pdf)

Additionally, run `man qemu-system-x86_64` or `man qemu-kvm` and see [QEMU Quickstart](https://qemu.weilnetz.de/doc/qemu-doc.html#pcsys_005fquickstart) for a more detailed explaination of each of the qemu options/flags. 

### [Qemu Binaries Explained](#qemu-bin-explain)

On the terminal, type `qemu-` and hit tab. You may notice that there's a number of qemu commands.

```
qemu-aarch64              qemu-io                   qemu-mipsel               qemu-ppc64le              qemu-system-alpha         qemu-system-mips64        qemu-system-s390x         qemu-system-xtensaeb
qemu-alpha                qemu-keymap               qemu-mipsn32              qemu-pr-helper            qemu-system-arm           qemu-system-mips64el      qemu-system-sh4           qemu-x86_64
qemu-arm                  qemu-kvm                  qemu-mipsn32el            qemu-s390x                qemu-system-cris          qemu-system-mipsel        qemu-system-sh4eb
qemu-armeb                qemu-m68k                 qemu-nbd                  qemu-sh4                  qemu-system-i386          qemu-system-moxie         qemu-system-sparc
qemu-cris                 qemu-microblaze           qemu-nios2                qemu-sh4eb                qemu-system-lm32          qemu-system-nios2         qemu-system-sparc64
qemu-ga                   qemu-microblazeel         qemu-or1k                 qemu-sparc                qemu-system-m68k          qemu-system-or1k          qemu-system-tricore
qemu-hppa                 qemu-mips                 qemu-ppc                  qemu-sparc32plus          qemu-system-microblaze    qemu-system-ppc           qemu-system-unicore32
qemu-i386                 qemu-mips64               qemu-ppc64                qemu-sparc64              qemu-system-microblazeel  qemu-system-ppc64         qemu-system-x86_64
qemu-img                  qemu-mips64el             qemu-ppc64abi32           qemu-system-aarch64       qemu-system-mips          qemu-system-ppcemb        qemu-system-xtensa
```
> A full QEMU installation includes several binaries, each of which emulates a different CPU architecture. 
> The binary filenames take the form `qemu-system-arch`, where arch is an architecture code, such as ppc for PowerPC or x86_64 for x86-64. 
> An exception is x86 systems, which are emulated via the qemu binary. 
>
> Binaries with names of the form `qemu-arch` provide user-mode emulation for their respective architectures. 
>
> [[sourced from a IBM developer blog post](https://www.ibm.com/developerworks/library/l-qemu-development/index.html)]

**If the above explaination wasn't enough**:

The `qemu-system-*` binaries e.g. qemu-system-i386 or qemu-system-x86_64 are used depending on guest OS's architecture. [[sourced from the ArchLinux Wiki KVM page](https://wiki.archlinux.org/index.php/QEMU#Enabling_KVM)]

Whereas `qemu-arch` is for running the specified arch under Linux without starting an actual virtual machine with that architecture. [[Sourced from a GNU email thread](https://lists.gnu.org/archive/html/qemu-discuss/2016-04/msg00013.html) and [a ServerFault forum discussion](https://serverfault.com/questions/767212/difference-between-qemu-kvm-qemu-system-x86-64-qemu-x86-64)]

Note: `qemu-kvm` is the equivalent to `qemu-system-x86_64 --enable kvm`. [[sourced from a GNU email thread](https://lists.gnu.org/archive/html/qemu-discuss/2012-02/msg00018.html)]


## [Logging into a QEMU VM](#login-to-qemu-kvm)
..
..
..
..
..
..


## [Managing a QEMU VM](#managing-a-qemu-vm)

### [The QEMU Console](#the-qemu-console)

When a VM instance is booted without the `-ncurses` option, [enter the QEMU console by pressing](https://stackoverflow.com/questions/14165158/how-to-switch-to-qemu-monitor-console-when-running-with-curses) <kbd>esc</kdd> + 2 and <kbd>esc</kbd> + 1 to switch back.

With the `-nographic` option, press <kbd>ctrl</kbd> + a then c to switch back and forth between the QEMU console and the VM. 

If none of the above options were used, press <kbd>ctrl</kbd> + <kbd>alt</kbd> then 2 to enter the console and with <kbd>ctrl</kbd> + <kbd>alt</kbd> then 1 to go back.

### [Shutdown and Starting up the Same Instance](#shutdown-Startup)

**Shutting down** is simply clicking [x] on the tool-bar of the Qemu monitor console or doing <kbd>CTRL</kbd>+<kbd>c</kbd> on the terminal where the `qemu-kvm` command was initiated.
It is also possible to shutdown the VM by pressing <kbd>CTRL</kbd>+<kbd>a</kbd> and then <kbd>c</kbd> when focus is on the QEMU monitor console (this is if the `-nographic` option was used).
Cached memory on the VM will not be saved but whatever that was saved to disk is persistent since all data is saved with the `rhcos.qcow2.qemu` file; a raw disk image.

**Starting up** is by running same command again, as long as the `-drive file=` option was provided with the same disk image as before. If a new clean VM of the same OS is needed, download or use `qemu-img create` a new raw disk image of the same OS.
Then provide that file within the `-drive file=` option. Essentially, the raw disk image is the identity of a particular VM. 

### [Saving the State of a VM](#save-state)

It is possible to make **snapshots** of a VM at a given state, see page 101 of the [OpenSUSE Virtualization with KVM book](https://www.suse.com/documentation/opensuse121/pdfdoc/book_kvm/book_kvm.pdf). 
Note that the snapshots will be saved within a given raw disk image. It is not available globally.

---

- change image file example
- add vnc logging
- add logging details 