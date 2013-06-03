#!/bin/bash
#
# Add new schema to the LDAP installation
#
# Usage: addschema.sh schema_file
#
# (C) Gonzalo Alvarez, 2013
#

SLAPCAT="/usr/sbin/slapcat"
LDAPADD="/usr/bin/ldapadd"

if [ -z "$1" ]; then
	cat <<EOF
LDAP Schema installer
 Usage: $0 schema_file
EOF
	exit 1
fi

SCHEMA_FILE="$(dirname $(readlink -f $1))/$(basename $(readlink -f $1))"

if [ ! -r "$SCHEMA_FILE" ]; then
	cat <<EOF
The file does not exists or it is not readable.
EOF
	exit 1
fi

if [ ! -x "$SLAPCAT" ]; then
	cat <<EOF
slapcat is not installed, but it is needed. Please consider installing it.
EOF
	exit 1
fi

if [ ! -x "$SLAPADD" ]; then
	cat <<EOF
ldapadd is required. Please consider installing.
EOF
	exit 1;
fi

CONF_FILE="$(mktemp)"
SCHEMA_DIR="$(mktemp -d)"
LDIF_FILE="$(mktemp)"

echo "include $SCHEMA_FILE" > $CONF_FILE

DN_OUTPUT="$($SLAPCAT -f $CONF_FILE -F $SCHEMA_DIR -n 0 | grep ,cn=schema | cut -d ':' -f 2 | sed 's/^ *//g')"

$SLAPCAT -f "$CONF_FILE" -F "$SCHEMA_DIR" -n0 -H ldap:///${DN_OUTPUT} -l "$LDIF_FILE"
sed -i '1,3s/{[0-9]}//' "$LDIF_FILE"
sed -i '/entryUUID:/d' "$LDIF_FILE"
sed -i '/creatorsName:/d' "$LDIF_FILE"
sed -i '/structuralObjectClass:/d' "$LDIF_FILE"
sed -i '/createTimestamp:/d' "$LDIF_FILE"
sed -i '/entryCSN:/d' "$LDIF_FILE"
sed -i '/modifiersName:/d' "$LDIF_FILE"
sed -i '/modifyTimestamp:/d' "$LDIF_FILE"
$LDAPADD -Q -Y EXTERNAL -H ldapi:/// -f "$LDIF_FILE"
rm -Rf "$CONF_FILE" "$SCHEMA_DIR" "$LDIF_FILE"

