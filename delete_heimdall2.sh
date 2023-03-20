#!/bin/bash

# Copyright (C) 2021 Michael Joseph Walsh - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the the license.
#
# You should have received a copy of the license with
# this file. If not, please email <mjwalsh@nemonik.com>

# Uninstall Heimdall2

source .env

NAMESPACE="heimdall"

helm uninstall heimdall -n $NAMESPACE
