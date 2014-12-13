#Packer Windows Development Build Template
This packer build template will build a vagrant basebox with the following installed:
+ Windows 8.1 Enterprise Eval
+ Sql Server 2012 Express with Tools
+ Visual Studion 2013 Community
+ IIS 8.5
+ Chrome 64 bit
+ SublimeText3
+ Git


#Prerequisites:
Virtualbox
Packer 
Vagrant


#Intructions
To build the basebox with the KMS VLK version of Windows 8.1 Enterprise run the following:

Clone this repository to you local machine

packer build win81_dev.json

vagrant box add win81_dev windows_81_virtualbox.box

NOTE: make sure you have added packer to your path for the "packer" command to work from any directory

The build process will take a long time(several hours depending on your connection speed) so kick back and let packer work its magic.  
It will also require significant free disk space(because Windows is massive and bloaty), the final basebox is around 14GB but will require 
at least 75GB of free disk space for the script to build the inital VM and then create the basebox.

For an example of a Vagrantfile which is extremely useful for use with this basebox look in the examples folder.  It has examples of 
automatically provisioning databases, additional IIS components and some other goodies.


#Notes
This is heavily based on the packer-windows project by Joe Fitzgerald

https://github.com/joefitzgerald/packer-windows