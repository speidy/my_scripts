import hashlib,binascii
from sys import argv

def gen_ntlm_hash(password):
	hash = hashlib.new('md4', password.encode('utf-16le')).digest()
	return  binascii.hexlify(hash)
	
def main():
	if (len(argv) == 1):
		print "Usage: %s <Clear Text Password>" % argv[0]
		return False
	
	print "NTLM Hash: " + gen_ntlm_hash(argv[1])
	return True
	
if __name__ == "__main__":
	main()
