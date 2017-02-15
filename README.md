# Bin Package Installer

This package will allow us to install a Bash Package in a Bin dir using symbolic links.

By default will install in our `/home/$USER/bin` directory and made it available
from our PATH.

## How To Install

To use this package is recommended to install it locally.

Is possible to use it without install it locally. Please see How To Use section.


#### Lets use the self installer:

```
curl -L https://github.com/exadra37-bash/bin-package-installer/raw/0.0.1.0/self-installer.sh | bash -s
```

#### checking that was correctly installed

```
bpi --help
```

## How To Use

We can easily check how to use it at any time:

```bash
bpi --help
```

#### From Local Installation

It takes the form of `bpi <vendor-name> <package-name> <package-tag> <symlink:script_to_link>`.

```bash
bpi exadra37-bash my-personal-links 0.0.1.0 links:src/my-personal-links.sh
```

#### Without Installing Locally

Lets use CURL to run it directly from Github in form `CURL -L <git-url-to-raw-script> | bash -s <vendor-name> <package-name> <package-tag> <symlink:script_to_link>`.

```bash
curl -L https://github.com/exadra37-bash/bin-package-installer/raw/0.0.1.0/src/installer.sh | bash -s
exadra37-bash my-personal-links 0.0.1.0 links:src/my-personal-links.sh
```

#### Now lets try our recent installed bash package:

```bash
$ links

   Author: Exadra37(Paulo Silva) <exadra37ingmailpointcom>
     Site: https://exadra37.com
   Gitlab: https://gitlab.com/Exadra37
   Github: https://github.com/Exadra37
 Linkedin: https://uk.linkedin.com/in/exadra37
  Twitter: https://twitter.com/Exadra37

```

## How To Uninstall a Previously Installed Package

We can easily check how to use it at any time:

```bash
bpu --help
```

It takes the form of `bpu <vendor-name> <package-name> <symlink1,symlink2>`.

#### With Only One Symbolic Link

```bash
bpu exadra37-bash my-personal-links 0.0.1.0 links
```

#### With Several Symbolic Links

```bash
bpu exadra37-bash my-personal-links 0.0.1.0 links,links2
```
