https://github.com/idk/pdq

pdqOS - Script for Arch Linux x86_64 to reinstall pdqOS from github repos

Includes
--------

https://github.com/idk/awesomewm-X

https://github.com/idk/conky-X

https://github.com/idk/pdq-utils

https://github.com/idk/php

https://github.com/idk/etc

https://github.com/idk/systemd

https://github.com/idk/eggdrop-scripts

https://github.com/idk/zsh

https://github.com/idk/gh


INSTALL
-------

from livecd/liveusb
https://gist.github.com/4311373

from within existing arch linux
https://gist.github.com/4316973



SUMMARY
-------


In Arch Linux as YOURUSER right after fresh install:

	# wget http://is.gd/reinstaller -O rs.sh
	# sh rs.sh
    
DONE! :D
--------


PRIVACY FEATURES
----------------


Web browsing
------------

Tor primarily supports Firefox, but can also be used with Chromium.

`Firefox`

1. Enable auto proxy addon in the Addons tab and use per-site settings from toolbar icon.


2. In Preferences > Advanced > Network tab > Settings manually set Firefox to use the SOCKS proxy localhost with port 9050.

`Chromium`

You can simply run:

	$ chromium --proxy-server="socks://localhost:9050"


Instant Messaging
-----------------

`Pidgin`

Browse through preferences -> proxy and edit it to look like

	Proxy type 	SOCKS5
	Host 	        127.0.0.1
	Port 	        9050

From now on pidgin will be using Tor. In some cases, depending on how different accounts are configured in IM services you have set up, you might want to change their proxy settings. Go to Accounts -> Manage Accounts and modify the account you wish, in Proxy tab to read:

	Proxy type 	Use Global Proxy Settings

`Irssi`

	# nano /etc/tor/torrc

Append the line:

	mapaddress  10.40.40.40 p4fsi4ockecnea7l.onion

Then:

	 $ cd ~/.irssi/scripts/
	 $ wget http://www.freenode.net/sasl/cap_sasl.pl
	$ packer -S perl-crypt-openssl-bignum perl-crypt-blowfish perl-crypt-dh

`Start irssi`

	$ torify irssi

Load the script that will employ the SASL mechanism.
	
	/script load cap_sasl.pl

Set your identification to nickserv, which will be read when connecting. Supported mechanisms are PLAIN and DH-BLOWFISH.
	
	/sasl set <network> <username> <password> <mechanism>

Connect to network:

	/connect -network <network> 10.40.40.40

`Torify`

torify will allow you use an application via the Tor network without the need to make configuration changes to the application involved. From the man page:
torify is a simple wrapper that calls tsocks with a tor specific configuration file. tsocks itself is a wrapper between the tsocks library and the application that you would like to run socksified

Usage example:

	$ torify elinks checkip.dyndns.org
	$ torify wget -qO- https://check.torproject.org/ | grep -i congratulations

Torify will not, however, perform DNS lookups through the Tor network. A workaround is to use it in conjunction with tor-resolve (described above). In this case, the procedure for the first of the above examples would look like this:

	$ tor-resolve checkip.dyndns.org

208.78.69.70
	
	$ torify elinks 208.78.69.70


https://trac.torproject.org/projects/tor/wiki/doc/SupportPrograms


LAMP
----

If you want to change/update the above root password, then you need to use the following command:

	$ mysqladmin -u root -p'oldpassword' password newpasswordhere

For example, you can set the new password to 123456, enter:

	$ mysqladmin -u root -p'oldpassword' password '123456'"


INCLUDES
--------

For a full list of packages view main.lst and local.lst.

=)
