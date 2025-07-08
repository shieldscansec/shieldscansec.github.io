#!/bin/bash
echo "Verificando sintaxe do gamemode..."
grep -n ";" gamemodes/rjroleplay_main.pwn | tail -5
