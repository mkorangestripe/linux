# Convert between hexadecimal and decimal:
printf "%x\n" 123  # 7b
printf "%d\n" 0x7b  # 123

# hexdump, od
echo 123 | hexdump  # 3231 0a33 (hex value of characters 123 - little-endian byte order)
echo ABC | hexdump  # 4241 0a43 (hexadecimal 2-byte units of characters ABC)
echo ABC | od -x  # 4241 0a43 (hexadecimal 2-byte units of characters ABC)
echo ABC | hexdump -C  # 41 42 43 0a  |ABC.| (hex+ASCII of characters ABC)
echo ABC | od -a -b  # A   B   C  nl (ASCII named characters of ABC, octal values on next line)
echo ABC | od -c  # A   B   C  \n (ASCII characters or backslash escapes)

# Base64
echo "green, yellow, bright orange" | base64 > encoded.txt
base64 -d encoded.txt  # green, yellow, bright orange
