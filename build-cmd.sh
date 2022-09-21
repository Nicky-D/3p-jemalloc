#!/bin/bash

cd "$(dirname "$0")"

set -xe

if [ -z "$AUTOBUILD" ] ; then
    fail
fi

SOURCE_DIR="jemalloc"

# load autbuild provided shell functions and variables
eval "$("$AUTOBUILD" source_environment)"

top="$(pwd)"
stage="$(pwd)/stage"


case "$AUTOBUILD_PLATFORM" in
        "linux64")

			cd ${top}/${SOURCE_DIR}
			./autogen.sh
			make -j `nproc`

			mkdir -p ${stage}/lib/release/
			mkdir -p ${stage}/LICENSES/
			
			cp lib/* ${stage}/lib/release/
			cat include/jemalloc/jemalloc.h | sed -n 's/#define JEMALLOC_VERSION //p'  | tr -d '"' > ${stage}/VERSION.txt
			cp COPYING ${stage}/LICENSES/jemalloc.txt
			;;
		*)
			echo "Unsupported platform ${AUTOBUILD_PLATFORM}"
			exit 1
			;;
		esac
