LDAP Helper Scripts
===================

The following scripts are intended to ease the administration of a OpenLDAP installation.
Most scripts have the following requirements

* SLAP utils
* LDAP utils

LDAP Add Schema
---------------

This script is intended to easily allow you to add a new schema to your OpenLDAP installation.

Example of usage:

    # addschema.sh /usr/share/doc/isc-dhcp-server-ldap/dhcp.schema

It requires the schema file to be uncompressed.
