#!/bin/bash
set e

# Instalacion de dependencias front
sudo apt update -y
sudo apt install nodejs -y
sudo apt install build-essential -y
sudo apt install npm -y
sudo npm install -g @angular/cli