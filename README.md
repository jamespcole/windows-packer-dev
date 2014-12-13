#Packer Windows Development Build Template
This packer build template will build a vagrant basebox with the following installed:
+ Windows 8.1 Enterprise Eval
+ Sql Server 2012 Express with Tools
+ Visual Studion 2013 Community
+ IIS 8.5
+ Chrome 64 bit
+ SublimeText3
+ Git + Bash

The purpose of this template is to provide an easy way to provision vagrant base boxes for windows development for you and your team.  
It contains the basic tools necessary for windows development, you should place any project specific provisioning in your vagrant file.  
For an example of a useful vagrant file designed to be used with this basebox check out the "examples" directory.

By default this template uses the evaluation version of Windows 8.1 enterprise with the default key.  If you wish to use your own ISO 
and product key read the "Product Keys" and Getting Started" section in the packer-windows ReadMe.md here https://github.com/joefitzgerald/packer-windows


##Prerequisites
Before you start you need to install the following:

+ Virtualbox >= 4.3.18 - https://www.virtualbox.org/
+ Packer >= 0.7.2 - https://packer.io/
+ Vagrant >= 1.6.5 - https://www.vagrantup.com/


##Instructions
To build the basebox with Windows 8.1 Enterprise Eval run the following:

Clone this repository to you local machine

`packer build win81_dev.json`

`vagrant box add win81_dev win81_dev_virtualbox.box`

Now copy /examples/vagrant/Vagrantfile and /examples/vagrant/provisioning into the root of your project, then in the directory where you 
placed the Vagrantfile enter the command:

`vagrant up`

NOTE: make sure you have added packer to your path for the "packer" command to work from any directory

The build process will take a long time(several hours depending on your connection speed) so kick back and let packer work its magic.  
It will also require significant free disk space(because Windows is massive and bloaty), the final basebox is around 14GB but will require 
at least 75GB of free disk space for the script to build the inital VM and then create the basebox.

For an example of a Vagrantfile which is extremely useful for use with this basebox look in the examples folder.  It has examples of 
automatically provisioning databases, additional IIS components and some other goodies.


##Customising the template
If you are customising the template you may find it useful to set the "headless" property in the win81_dev.json file to false so that you can 
see the GUI while the template is bulding.

It may also be useful to speed things up by turning off windows updating during install while testing.  To switch off updates during installation 
edit the answer_files/win81_dev/Autounattend.xml and comment in the section "WITHOUT WINDOWS UPDATES" and comment out the section "WITH WINDOWS UPDATES".

To add or remove the apps that are to be installed during the build take a look at script/dev-tools.ps1 and add any windows features or chocolatey install commands there.  
For various tweks and setting check out /scripts/customisations.bat

##Notes
This is heavily based on the packer-windows project by Joe Fitzgerald

https://github.com/joefitzgerald/packer-windows