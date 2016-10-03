#!/bin/bash

set -e

if grep "QT_STYLE_OVERRIDE=" /etc/environment &> /dev/null; then
    exit 0
fi

echo "export QT_STYLE_OVERRIDE=gtk" >> /etc/environment
