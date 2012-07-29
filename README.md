https://github.com/idk/pdq

https://www.youtube.com/watch?v=Cbl0vinkg2A&hd=1


Includes
--------

https://github.com/idk/awesomewm-X

https://github.com/idk/conky-X


INSTALL
-------

Install Arch linux base (preferably core-remote)
Then reboot then...
    
Install packages from my(your) git repo! :D
-------------------------------------------

As root right after fresh install:

	# wget http://is.gd/reinstaller -O reinstaller.sh
	# sh reinstaller.sh


DONE! :D
--------


FEATURES
--------

Instant Messaging

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