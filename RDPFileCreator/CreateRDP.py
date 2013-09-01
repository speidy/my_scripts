__author__ = 'Idan Freibreg'
# RDP File Creator
import win32crypt
import binascii
import argparse


def CryptRDPPass(ClearPass):
    pwdHash = win32crypt.CryptProtectData(unicode(ClearPass), 'pwd', None, None, None, 0)
    return binascii.hexlify(pwdHash)


def main(args):
    """
    Create RDP file with specific parameters requested by user.
    """

    #check for .rdp suffix, add it when needed
    if args.filename.split('.')[len(args.filename.split('.'))-1].lower() != 'rdp':
        args.filename += '.rdp'

    # Create our .rdp file
    fd = open(args.filename, 'w')
    fd.write('full address:s:' + args.host + '\n') # host is required by argparse
    if args.user:
        fd.write('username:s:' + args.user + '\n')
    if args.pwd:
        fd.write('password 51:b:' + CryptRDPPass(args.pwd) + '\n')
    if args.domain:
        fd.write('domain:s:' + args.domain + '\n')
    if raw_input('use multi monitor? [Y/N]').lower() == 'y':
        fd.write('use multimon:i:' + '1' + '\n')

    fd.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='RDP File Creator')
    parser.add_argument('-filename', metavar='ToscanaPC.rdp', nargs='?',
                        help='Name for RDP file to create', required=True)
    parser.add_argument('-host', metavar='hostname', nargs='?',
                        help='Hostname or IP to connect using RDP', required=True)
    parser.add_argument('-user', metavar='username', nargs='?',
                        help='Your username')
    parser.add_argument('-domain', metavar='domain', nargs='?',
                        help='enter domain name')
    parser.add_argument('-pwd', metavar='password', nargs='?',
                        help='Your password')
    args = parser.parse_args()

    main(args)