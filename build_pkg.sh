#!/bin/bash

#sudo apt-get install -y gcc dpkg-dev gpg

install_path=usr/bin
architecture='amd64'

script_list=($(ls -I build_pkg.sh -I generate-release.sh -I apt-repo))

for file in "${script_list[@]}"; do
	sed -i "s/abc/$install_path/g" $file
	source $file
	version=$version
	alias=$alias
	echo "Packing: $file version: $version alias: $alias"
	echo "creating dirs for $file"
	mkdir -p "${file%.*}_${version}_$architecture/$install_path"
	cp -p $file "${file%.*}_${version}_$architecture/$install_path/$alias"
	mkdir -p "${file%.*}_${version}_$architecture/DEBIAN"

	echo "Package: ${file%.*}
Version: $version
Architecture: amd64
Maintainer: Vladimir Glayzer
Homepage: http://example.com
eMail: its_a_vio@hotmail.com
Description: ${file%.*}" > "${file%.*}_${version}_$architecture/DEBIAN/control"

	echo "chmod 777 /$install_path/$alias
	mkdir -p ~/script_files" > "${file%.*}_${version}_$architecture/DEBIAN/postinst"
	
	chmod 775 "${file%.*}_${version}_$architecture/DEBIAN/postinst"

	dpkg --build ./${file%.*}_${version}_$architecture
	
	#mv "${file%.*}_${version}_$architecture.deb" "./apt-repo/pool/main/${file%.*}_${version}_$architecture.deb"

	#rm -r ${file%.*}_${version}_$architecture
done


