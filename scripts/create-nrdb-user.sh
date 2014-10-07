#!/bin/bash

password=$(pwgen -s 12 1)
useradd -m -p $password -G sudo nrdb

echo ===============================================================================
echo Created user \"nrdb\" with password \"$password\"
echo ===============================================================================
