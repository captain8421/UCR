#!/bin/bash
echo -e "\033[0;32mHow many CPU cores do you want to be used in compiling process? (Default is 1. Press enter for default.)\033[0m"
read -e CPU_CORES
if [ -z "$CPU_CORES" ]
then
	CPU_CORES=1
fi

# Upgrade the system and install required dependencies
	sudo apt update && sudo apt upgrade
	sudo apt install git zip unzip build-essential libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 curl g++-mingw-w64-x86-64 -y
	echo "1" | sudo update-alternatives --config x86_64-w64-mingw32-g++

# Clone UCR code from UCR official Github repository
	git clone https://github.com/sapphire-pt/UCR.git

# Entering UCR directory
	cd UCR

# Compile dependencies
	cd depends
	chmod +x config.sub
	chmod +x config.guess
	make -j$(echo $CPU_CORES) HOST=x86_64-w64-mingw32 
	cd ..

# Compile UCR
	chmod +x share/genbuild.sh
	chmod +x autogen.sh
	./autogen.sh
	./configure --prefix=$(pwd)/depends/x86_64-w64-mingw32 --disable-debug --disable-tests --disable-bench CFLAGS="-O3" CXXFLAGS="-O3"
	make -j$(echo $CPU_CORES) HOST=x86_64-w64-mingw32
	cd ..

# Create zip file of binaries
	cp UCR/src/ucrd.exe UCR/src/ucr-cli.exe UCR/src/ucr-tx.exe UCR/src/qt/ucr-qt.exe .
	zip UCR-Windows.zip ucrd.exe ucr-cli.exe ucr-tx.exe ucr-qt.exe
	rm -f ucrd.exe ucr-cli.exe ucr-tx.exe ucr-qt.exe