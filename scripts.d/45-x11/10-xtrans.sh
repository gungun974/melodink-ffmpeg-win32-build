#!/bin/bash

SCRIPT_REPO="https://gitlab.freedesktop.org/xorg/lib/libxtrans.git"
SCRIPT_COMMIT="e69d45306f38367ce3a0a5fa126beeb4e6370585"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --without-xmlto
        --without-fop
        --without-xsltproc
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install

    cp -r "$FFBUILD_PREFIX"/share/aclocal/. /usr/share/aclocal
}
