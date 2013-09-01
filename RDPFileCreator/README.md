RDP File Creator
----------------
    * Creates embeded .RDP file , include encrypted password.
    * Pre Req: 
        * python 2.7 on windows
        * pywin32
    * Limitations: 
        *since assword is encrypted locally, the .RDP file cannot be used out of the same User profile session.

Usage
-----------------
    usage: CreateRDP.py [-h] -filename [ToscanaPC.rdp] -host [hostname]
                        [-user [username]] [-domain [domain]] [-pwd [password]]

    RDP File Creator

    optional arguments:
      -h, --help            show this help message and exit
      -filename [ToscanaPC.rdp]
                            Name for RDP file to create
      -host [hostname]      Hostname or IP to connect using RDP
      -user [username]      Your username
      -domain [domain]      enter domain name
      -pwd [password]       Your password
