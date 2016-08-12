# mlocate

[![Build Status](https://travis-ci.org/adamcrews/puppet-mlocate.svg)](https://travis-ci.org/adamcrews/puppet-mlocate)
[![Puppet Forge](http://img.shields.io/puppetforge/v/adamcrews/mlocate.svg)](http://forge.puppetlabs.com/adamcrews/mlocate)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mlocate](#setup)
    * [What mlocate affects](#what-mlocate-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mlocate](#beginning-with-mlocate)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
      * [Public Classes](#public-classes)
      * [Private Classes](#private-classes)
    * [Parameters](#parameters)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [ToDo](#todo)
7. [Contributors](#contributors)

## Overview

Install and manage the mlocate/updatedb package.

## Module Description

Mlocate is a useful tool that does a find of your system and records the files present.
It's a bit old, not commonly used, irrelevant on disposable systems, but I like it, so get off my lawn.

## Setup

### What mlocate affects

* installs the mlocate package
* removes the default cron job, and replaces it with one that is splayed via fqdn_rand

### Setup Requirements

You need a modern puppetlabs/stdlib.

### Beginning with mlocate

Everything can be configured via the default mlocate class.

## Usage

Basic usage that will result is a setup very close to a default CentOS configuration

```puppet
include ::mlocate
```

Exclude some directories:

```puppet
class { '::mlocate':
  extra_prunepaths => [ '/exports', '/data' ],
}
```

## Reference

### Classes

#### Public Classes

* mlocate: Main class, includes other classes.

#### Private Classes

* mlocate::params: default parameters.
* mlocate::install: install and configure the software.
* mlocate::cron: setup the cron job.

###Parameters

The following parameters are available as options to the default mlocate class.

####`package_name`

The name of the package to install. Default: mlocate

####`package_ensure`

Ensure the package is present, latest, or absent. Default: present

####`update_command_path`

The path of the updatedb wrapper script. Default: $update_command

####`update_command`

The name of the updatedb wrapper script. Default: /usr/local/bin/mlocate.cron

####`update_on_install`

Run an initial update when the package is installed. Default: true

####`conf_file`

The configuration file for updatedb. Default: /etc/updatedb.conf

####`cron_ensure`

Ensure the cron jobs is present or absent. Default: present

####`cron_schedule`

The standard cron time schedule. Default: once a week based on fqdn_rand

####`cron_daily_path`

The path to cron.daily file installed by mlocate and that is removed

####`prune_bind_mounts`

Prune out bind mounts or not. Default: yes
Refer to the updatedb.conf man page for more detail.
On redhat 5 systems defaults to none.

####`prunenames`

Prune out directories matching this pattern. Default: .git .hg .svn
Refer to the updatedb.conf man page for more detail.
On redhat 5 systems defaults to none.

####`extra_prunenames`

Prune out additional directories matching this pattern. Default: none

####`prunefs`

Prune out these FS types. Default: refer to the params.pp
Refer to the updatedb.conf man page for more detail.

####`extra_prunefs`

Prune out additional directories matching this pattern. Default: none

####`prunepaths`

Prune out paths matching this pattern. Default: refer to params.pp
Refer to the updatedb.conf man page for more detail.

####`extra_prunepaths`

Prune out additional directories matching this pattern. Default: none

## Limitations

This has only been tested on CentOS 6.5, but should work fine on any RHEL based system, versions 4+

## Development

Please add spec tests, and submit PR's from a branch.

### ToDo

More spec tests are needed.

### Misc

With the 0.3.0 release, the cron job times will likely change as an extra seed argument has been added to the fqdn_rand function calls.  This is a workaround for https://tickets.puppetlabs.com/browse/PUP-5646

## Contributors

Contributors can be found on github.

