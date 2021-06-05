#!/bin/bash
set -e

# Instalacion dependencias
sudo apt-get update -y 
sudo apt-get install openjdk-8-jdk openjdk-11-jdk wget unzip -y
sudo apt install maven -y
sudo apt install gradle -y