# Launching an Atomic Host Virtual Machine

Follow these installation guides for: [Vagrant on Fedora](https://developer.fedoraproject.org/tools/vagrant/about.html)

- [Using Vagrant](#using-vagrant)
    - [Creating a Vagrant Box](#creating-a-vagrant-box)
    - [Create a directory for Vagrantfile](#create-a-directory-for-vagrantfile)
    - [Pulling an Image from Vagrant Cloud](#pulling-an-image-from-vagrant-cloud)
    - [Vagrant init and Get it Running](#vagrant-init-and-get-it-running)
    - [Overall Vagrant Commands](#overall-vagrant-commands)
    - [Login to Atomic Host VM](#login-to-atomic-host)
    - [Troubleshooting `vagrant init`](#troubleshooting-vagrant-init)
    - [Troubleshooting `vagrant up`](#troubleshooting-vagrant-up)

---

## [Using Vagrant](#using-vagrant)

There's two ways of creating a Vagrant VM:

[From scratch using an image file](#creating-a-vagrant-box) OR [Using an image from Vagrant Cloud](#pulling-an-image-from-vagrant-cloud).

See [Overall Commands](#overall-commands) for contrast.

### [Creating a Vagrant Box](#creating-a-vagrant-box)

Skip this step if the image will be pulled from Vagrant Cloud.
Go to [Pulling an Image from Vagrant Cloud](#pulling-an-image-from-vagrant-cloud)

Otherwise, download a `vagrant-libvirt.box` from source or through this [link](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-28-20180709.0/AtomicHost/x86_64/images/Fedora-AtomicHost-Vagrant-28-20180709.0.x86_64.vagrant-libvirt.box).

Within the same directory as the downloaded image or specify the path to the image file, run:
```bash
$ vagrant box add --name AH28 Fedora-AtomicHost-Vagrant-28-20180709.0.x86_64.vagrant-libvirt.box
.
.
box: Successfully added box 'AH28' (v0) for 'libvirt'!
```

### [Create a directory for Vagrantfile](#create-a-directory-for-vagrantfile)

This is where, `Vagrantfile`, the VM's configs, directories and etc will live.

On any directory that you prefer, run:

```
$ mkdir atomic && cd atomic
```

If you've created a Vagrant Box from scratch skip [Pulling an Image from Vagrant Cloud](#pulling-an-image-from-vagrant-cloud) and go to [Creating an Atomic Host VM and Get it Running](#creating-an-atomic-host-vm-and-get-it-running).

### [Pulling an Image from Vagrant Cloud](#pulling-an-image-from-vagrant-cloud)

After [creating a directory for Vagrantfile]((#create-a-directory-for-vagrantfile)), the following commands will pull the Atomic Host image, create the VM and get it running:

```bash
$ vagrant init fedora/28-atomic-host && vagrant up
```
[Source to Vagrant Boxhosted on Vagrant Cloud](https://app.vagrantup.com/fedora/boxes/28-atomic-host).

### [Vagrant init and Get it Running](#vagrant-init-and-get-it-running)

If you've skipped [Pulling an Image from Vagrant Cloud](#pulling-an-image-from-vagrant-cloud), run:

```bash
vagrant init AH28 && vagrant up
```

### [Overall Vagrant Commands](#overall-vagrant-commands)

|Launching Vagrant from a Custom Vagrant Box| Using Vagrant Cloud |
| --- | --- |
|```$ vagrant box add --name BoxName some-image.vagrant-libvirt.box ```<br/>```$ mkdir atomic && cd atomic```<br/>```$ vagrant init BoxName && vagrant up```|```$ mkdir atomic && cd atomic```<br/>```vagrant init fedora/28-atomic-host && vagrant up```|

### [Login to Atomic Host VM](#login-to-atomic-host)

```bash
$ vagrant ssh
```
To see more information about the VM's ssh configuration, run:

```
$ vagrant ssh-config
Host default
  HostName 192.168.121.131
  User vagrant
  Port 22
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
```
### [Troubleshooting `vagrant init`](#troubleshooting-vagrant-init)

```
$ vagrant up 
Bringing machine 'default' up with 'libvirt' provider...
Name `atomic_default` of domain about to create is already taken. Please try to run `vagrant up` command again.
```

This happens when the directory named `atomic` had a VM created in it  but was later `vagrant destroy` -ed and then a different VM was created within the same `atomic` directory.

The workaround, as show on this [github discussion](https://github.com/jonnyzzz/TeamCity.Virtual/issues/38):

Change the following in the Vagrantfile from
```
.
.
config.vm.define "atomic_default" do |atomic_default|
end
.
.
``` 
to:

```
config.vm.define "atomic_default" do |atomic_28|
end
```

Stackoverflow [discusion on changing default machine name](https://stackoverflow.com/questions/17845637/how-to-change-vagrant-default-machine-name).

### [Troubleshooting `vagrant up`](#troubleshooting-vagrant-up)

An error relating to `Mounting NFS shared folders` for sharing files between the VM and hosting machine, may happen.

Un-comment the following line in the Vagrantfile and add `, disabled:true` as such:

```
.
.
config.vm.synced_folder ".", "/vagrant", disabled: true
.
.
```

See the [workaround and discussion here](https://gist.github.com/Bubblemelon/5fe5b3773da4c55c058601feb8d9bda6).