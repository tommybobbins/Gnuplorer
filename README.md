Gnuplorer
=========

Grab all configuration information from a *nux box. shell script to gather the entire configuration of a GNU/Linux/Unix server. It is intended to collect approximately the same configuration information as Sun's explorer used to . This will help a user to rebuild systems following catastrophic failure or after a failed upgrade. It is without some of the problematical licences associated with alternative collection products.

Update: Since I wrote gnuplorer, I have discovered Dconf, which is a great product written in Python with a monolithic output file.. If you require a snapshot of a system which can be diffed at a later date, then download Dconf instead of Gnuplorer. If you don't want to use Python and/or want to preserve the configuration file hierarchy, then I would recommend Gnuplorer.

Then as root run:

    # cd Gnuplorer
    # make install

Or using sudo:

    $ cd Gnuplorer
    $ sudo make install 


To install gnuplorer to a different default location other than /usr/local/gnuplorer, please edit the Makefile and change the DESTDIR variable. Alternatively, set the environment variable DESTDIR before running make install
You should also then edit the gnuplorer.sh CONFDIR.

e.g

    $ export DESTDIR=/opt/gnuplorer
    $ make install
