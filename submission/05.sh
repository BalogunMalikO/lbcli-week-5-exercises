# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

BLOCKHEIGHTS=150

hex=$(printf '%08x\n' $BLOCKHEIGHTS | sed 's/^\(00\)*//');

hexfirst=$(echo $hex | cut -c1)
[[ 0x$hexfirst -gt 0x7 ]] && hex="00"$hex

LEHEX=$(echo $hex | tac -rs .. | echo "$(tr -d '\n')");

SIZE=$(echo -n $lehex | wc -c | awk '{print $1/2}')

PUBKEY_HASH=$(echo $publicKey | xxd -r -p | openssl sha256 -binary | openssl rmd160 | cut -d' ' -f2)

#OP_PUSHDATA <BLOCKHEIGHT_LE_LENGTH> <BLOCKHEIGHT> OP_CHECKSEQUENCEVERIFY OP_DROP OP_DUP OP_HASH160 OP_PUSHDATA <PUBKEYHASHLENGTH> OP_EQUALVERIFY OP_CHECKSIG 
CSV_SCIPT="0$SIZE"$LEHEX"b27576a914"$PUBKEY_HASH"88ac" 

echo $CSV_SCIPT