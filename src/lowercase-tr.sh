#!/bin/bash

#################################################################################
#
# Lowercase Turkish input stream.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# Translate uppercase chars to lowercase.
# tr command doesn't work with I->ı and İ->i convertions
tr 'Ğ' 'ğ' |
tr 'Ü' 'ü' |
tr 'Ö' 'ö' |
tr 'Ç' 'ç' |
tr 'Ş' 'ş' |
sed "s/I/ı/g" |
sed "s/İ/i/g" |
tr '[:upper:]' '[:lower:]' 