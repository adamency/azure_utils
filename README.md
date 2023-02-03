# Azure Utils
###### @Adamency

### Summary

Collections of scripts for manipulating Azure resources programmatically.

### Legend

With $\color{orange}\text{scriptname}$ the base name of a script:

<br>- $\color{orange}\text{scriptname}$.ps1<br/>

is a powershell script

<br>- $\color{orange}\text{scriptname}$.sh<br/>

is a Unix shell script (*may use some bash-only constructs.*)

<br>- $\color{orange}\text{scriptname}$.unixified.ps1<br/>

is a powershell script which uses some Unix commands (all can be installed on Windows with [`scoop`](https://github.com/scopinstaller/scoop))

<br>- $\color{orange}\text{scriptname}$.shell_config.ps1<br/>

is powershell code meant to be put in a Powershell configuration script, what microsoft calls a "profile". It is accessible with `vim $profile` (or any other editor) inside a Powershell session.

<br>- $\color{orange}\text{scriptname}$.shell_config.sh<br/>

is shell code meant to be put in a Unix shell configuration script, typically `~/.bashrc`.

