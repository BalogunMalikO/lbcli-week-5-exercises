# Create a CLTV script with a timestamp of 1495584032 and public key below:
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

#CONVERT TO HEX
hex=$(printf '%08x\n' 1495584032 | sed 's/^\(00\)*//');


#CONVERT TO LITTLE ENDIAN
lehex=$(echo $hex | tac -rs .. | echo "$(tr -d '\n')");

#CRETEA CLTV

PUBKEY_HASH=$(echo $publicKey | xxd -r -p | openssl sha256 -binary | openssl rmd160 | cut -d' ' -f2)

SIZE=$(echo -n $lehex | wc -c | awk '(print $1/2)')

#OP_PUSHDATA 4bytes(SIZE) <TIMESTAMP> OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 OP_PUSHDATA 20bytes <PUBKEY_HASH> OP_EQUALVERIFY OP_CHECKSIG 
serializedScript="0$SIZE"$lehex"b17576a914"$pubkeyhash"88ac" 

echo $serializedScript