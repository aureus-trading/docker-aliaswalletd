#!/bin/bash
set -e

testAlias+=(
	[spectrecoind:trusty]='spectrecoind'
)

imageTests+=(
	[spectrecoind]='
		rpcpassword
	'
)
