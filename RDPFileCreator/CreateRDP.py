__author__ = 'Idan Freibreg'
# RDP File Creator
import win32crypt
import binascii
import argparse


def CryptRDPPass(ClearPass):
    pwdHash = win32crypt.CryptProtectData(ClearPass, 'pwd', None, None, None, 0)
    print binascii.hexlify(pwdHash)


def main(filename, host, user, pwd):
    """
    Create RDP file with specific parameters requested by user.
    :param filename:
    :param host:
    :param user:
    :param pwd:
    """
    print filename, host, user, pwd

    if filename.split('.')[len(filename.split('.'))-1].lower() != 'rdp':
        filename += '.rdp'
        print(filename)

    if filename.split('.') == 'rdp':
        f = open(filename, 'w')
        f.write('username::i::' & user)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='RDP File Creator')
    parser.add_argument('-filename', metavar='ToscanaPC.rdp', nargs='?',
                        help='Name for RDP file to create', required=True)
    parser.add_argument('-host', metavar='hostname', nargs='?',
                        help='Hostname or IP to connect using RDP', required=True)
    parser.add_argument('-user', metavar='username', nargs='?',
                        help='Your username')
    parser.add_argument('-pwd', metavar='password', nargs='?',
                        help='Your password')
    args = parser.parse_args()

    main(args.filename,args.host,args.user,args.pwd)