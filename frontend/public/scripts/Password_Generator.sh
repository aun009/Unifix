#!/usr/bin/env bash
set -euo pipefail

# Password_Generator.sh
# Generate secure passwords or passphrases with multiple modes and options.
# Usage: Password_Generator.sh [-l length] [-n count] [-m mode] [-e exclude] [-w words] [-s master] [-a] [-h]
# Modes:
#   alnum       - letters + digits
#   complex     - letters (mixed) + digits + symbols (default)
#   hex         - hexadecimal
#   base64      - base64-encoded bytes
#   pronounce   - simple pronounceable (alternating consonant/vowel)
#   passphrase  - multiple dictionary words (Diceware-like)
#   memorable   - readable but lower entropy (not for high-security use)
# Examples:
#   Password_Generator.sh -l 20 -n 5
#   Password_Generator.sh -m passphrase -w 4 -n 3
#   Password_Generator.sh -m hex -l 32

LENGTH=16
COUNT=1
MODE="complex"
EXCLUDE=""
WORDS=4
MASTER=""
AVOID_AMBIGUOUS=0
QUIET=0

usage() {
  cat <<EOF
Usage: $0 [-l length] [-n count] [-m mode] [-e exclude] [-w words] [-s master] [-a] [-q] [-h]
  -l length    Password length (characters) or bytes for some modes. Default: ${LENGTH}
  -n count     How many passwords to generate. Default: ${COUNT}
  -m mode      Mode: alnum, complex, hex, base64, pronounce, passphrase, memorable
  -e exclude   Characters to exclude from generated passwords (e.g. "'\"/\\")
  -w words     Number of words for passphrase mode. Default: ${WORDS}
  -s master    Optional master/passphrase for deterministic passwords (HMAC-based)
  -a           Avoid ambiguous characters (0O1lI etc.)
  -q           Quiet: only output passwords (no explanation)
  -h           Show this help

Examples:
  $0 -l 20 -n 5
  $0 -m passphrase -w 5
  $0 -m pronounce -l 16
EOF
  exit 1
}

while getopts ":l:n:m:e:w:s:aqh" opt; do
  case "$opt" in
    l) LENGTH=$OPTARG ;;
    n) COUNT=$OPTARG ;;
    m) MODE=$OPTARG ;;
    e) EXCLUDE=$OPTARG ;;
    w) WORDS=$OPTARG ;;
    s) MASTER=$OPTARG ;;
    a) AVOID_AMBIGUOUS=1 ;;
    q) QUIET=1 ;;
    h) usage ;;
    *) usage ;;
  esac
done

# Character sets
LOWER='abcdefghijklmnopqrstuvwxyz'
UPPER='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
DIGITS='0123456789'
SYMBOLS='!@#$%^&*()-_=+[]{}<>:;,.?/'
AMBIGUOUS='0O1lI'

# Remove excluded/ambiguous chars from a charset
filter_charset() {
  local s="$1"
  local excl="$2"
  local out
  out=$(printf "%s" "$s" | tr -d "$excl")
  printf "%s" "$out"
}

# Deterministic hex bytes via HMAC-SHA256 (master, count bytes)
deterministic_rand_hex() {
  local master="$1"; local count=$2
  local out=""
  local counter=0
  while [[ ${#out} -lt $((count*2)) ]]; do
    # Use openssl to produce a binary HMAC and convert to hex
    h=$(printf "%s:%d" "$master" "$counter" | openssl dgst -sha256 -binary | xxd -p -c 256)
    out+="$h"
    counter=$((counter+1))
  done
  echo "${out:0:$((count*2))}"
}

# Map hex string to characters from charset
hex_to_chars() {
  local hex="$1"; local charset="$2"
  local clen=${#charset}
  local out=""
  # process two hex chars -> byte
  local i=0
  while [[ $i -lt ${#hex} ]]; do
    byte_hex=${hex:$i:2}
    byte=$((16#${byte_hex}))
    idx=$((byte % clen))
    out+="${charset:$idx:1}"
    i=$((i+2))
  done
  printf "%s" "$out"
}

# Generate a random password using either system RNG or deterministic HMAC
generate_password() {
  local length=$1
  local charset="$2"
  local master="$3"
  if [[ -n "$master" ]]; then
    # deterministic: get required bytes and map them
    hex=$(deterministic_rand_hex "$master" "$length")
    hex_to_chars "$hex" "$charset"
  else
    # non-deterministic: read from /dev/urandom and map
    local out=""
    local clen=${#charset}
    # read bytes
    local bytes
    bytes=$(dd if=/dev/urandom bs=1 count=$length 2>/dev/null | xxd -p -c 256)
    local i=0
    while [[ $i -lt ${#bytes} ]]; do
      byte_hex=${bytes:$i:2}
      byte=$((16#${byte_hex}))
      idx=$((byte % clen))
      out+="${charset:$idx:1}"
      i=$((i+2))
    done
    printf "%s" "$out"
  fi
}

# Pronounceable password (alternating consonant and vowel)
generate_pronounceable() {
  local length=$1
  local master="$2"
  local consonants="bcdfghjklmnpqrstvwxyz"
  local vowels="aeiou"
  if [[ $AVOID_AMBIGUOUS -eq 1 ]]; then
    consonants=$(filter_charset "$consonants" "$AMBIGUOUS")
  fi
  local out=""
  for ((i=0;i<length;i++)); do
    if (( i % 2 == 0 )); then
      # consonant
      if [[ -n "$master" ]]; then
        hex=$(deterministic_rand_hex "$master:$i" 1)
        out+="${consonants:$((16#${hex}%${#consonants})):1}"
      else
        out+="${consonants:RANDOM%${#consonants}:1}"
      fi
    else
      # vowel
      if [[ -n "$master" ]]; then
        hex=$(deterministic_rand_hex "$master:$i" 1)
        out+="${vowels:$((16#${hex}%${#vowels})):1}"
      else
        out+="${vowels:RANDOM%${#vowels}:1}"
      fi
    fi
  done
  printf "%s" "$out"
}

# Passphrase: pick WORDS words from a wordlist if available
generate_passphrase() {
  local words=$1
  local master="$2"
  local wordlist=""
  if [[ -f /usr/share/dict/words ]]; then
    wordlist="/usr/share/dict/words"
  elif [[ -f /usr/dict/words ]]; then
    wordlist="/usr/dict/words"
  fi
  local out=""
  if [[ -n "$wordlist" ]]; then
    local total=$(wc -l < "$wordlist")
    for ((i=0;i<words;i++)); do
      if [[ -n "$master" ]]; then
        # deterministic pick using HMAC
        hex=$(deterministic_rand_hex "$master:$i" 4)
        num=$((0x${hex}))
        idx=$((num % total + 1))
      else
        idx=$((RANDOM % total + 1))
      fi
      w=$(sed -n "${idx}p" "$wordlist" | tr -cd '[:alnum:]')
      out+="$w"
      if (( i < words-1 )); then out+="-"; fi
    done
  else
    # Fallback: generate pronounceable "words"
    for ((i=0;i<words;i++)); do
      w=$(generate_pronounceable 6 "$master:$i")
      out+="$w"
      if (( i < words-1 )); then out+="-"; fi
    done
  fi
  printf "%s" "$out"
}

# Calculate approximate entropy bits
entropy_bits() {
  local charset_len=$1
  local length=$2
  # bits = length * log2(charset_len)
  awk -v l=$length -v c=$charset_len 'BEGIN{printf "%.1f", l * log(c)/log(2)}'
}

# Build charset based on mode and flags
case "$MODE" in
  alnum)
    CHARSET="${LOWER}${UPPER}${DIGITS}"
    ;;
  complex)
    CHARSET="${LOWER}${UPPER}${DIGITS}${SYMBOLS}"
    ;;
  hex)
    CHARSET="0123456789abcdef"
    ;;
  base64)
    # base64 will be generated from random bytes instead of charset mapping
    CHARSET="BASE64"
    ;;
  pronounce)
    CHARSET="PRONOUNCE"
    ;;
  passphrase)
    CHARSET="PASSPHRASE"
    ;;
  memorable)
    CHARSET="${LOWER}${DIGITS}"
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    usage
    ;;
esac

# Apply exclusions and ambiguous avoidance
if [[ "$CHARSET" != "BASE64" && "$CHARSET" != "PRONOUNCE" && "$CHARSET" != "PASSPHRASE" ]]; then
  if [[ $AVOID_AMBIGUOUS -eq 1 ]]; then
    CHARSET=$(filter_charset "$CHARSET" "$AMBIGUOUS")
  fi
  if [[ -n "$EXCLUDE" ]]; then
    CHARSET=$(filter_charset "$CHARSET" "$EXCLUDE")
  fi
fi

# Generation loop
for ((c=0;c<COUNT;c++)); do
  if [[ $QUIET -ne 1 ]]; then
    echo "# Mode: $MODE  Length: $LENGTH"
  fi
  case "$CHARSET" in
    BASE64)
      if [[ -n "$MASTER" ]]; then
        # deterministic base64: HMAC-derived bytes
        hex=$(deterministic_rand_hex "$MASTER" $LENGTH)
        bytes=$(echo "$hex" | xxd -r -p | base64)
        pw=$(echo "$bytes" | tr -d '\n' | cut -c1-$LENGTH)
      else
        pw=$(head -c $LENGTH /dev/urandom | base64 | tr -d '\n' | cut -c1-$LENGTH)
      fi
      ;;
    PRONOUNCE)
      pw=$(generate_pronounceable $LENGTH "$MASTER")
      ;;
    PASSPHRASE)
      pw=$(generate_passphrase $WORDS "$MASTER")
      ;;
    *)
      pw=$(generate_password $LENGTH "$CHARSET" "$MASTER")
      ;;
  esac

  if [[ $QUIET -ne 1 ]]; then
    # show entropy estimate when meaningful
    if [[ "$CHARSET" != "PASSPHRASE" && "$CHARSET" != "PRONOUNCE" ]]; then
      clen=0
      if [[ "$CHARSET" == "BASE64" ]]; then
        clen=64
      else
        clen=${#CHARSET}
      fi
      bits=$(entropy_bits $clen $LENGTH)
      echo "Entropy (approx): ${bits} bits"
    fi
    echo "$pw"
  else
    echo "$pw"
  fi
done

exit 0
