import hashlib,binascii
from itertools import product
from sys import argv

def gen_ntlm_hash(password):
	hash = hashlib.new('md4', password.encode('utf-16le')).digest()
	return  binascii.hexlify(hash)
	

def bruteforce_cases(plain_pass, ntlm_hash, sub = ""):
    l = [(c, c.upper()) if not c.isdigit() else (c, ) for c in plain_pass.lower()]
    l = ["".join(item) for item in product(*l)]
    for v in l:
        if gen_ntlm_hash(v) == ntlm_hash:
           return v 
    return "Unknown"

def main():
	if (len(argv) == 1):
		print "Usage: %s <Clear Text Password>" % argv[0]
		return False
        elif (len(argv) == 2):
            print "NTLM Hash: " + gen_ntlm_hash(argv[1])
        elif (len(argv) == 3):
            print "Correct one is: " + bruteforce_cases(argv[1], argv[2])
	return True
	
if __name__ == "__main__":
	main()
