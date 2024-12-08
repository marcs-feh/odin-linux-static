set -eu

cd '/Odin'

: ${CPPFLAGS=}
: ${CXXFLAGS=}
: ${LDFLAGS=}
: ${LLVM_CONFIG=}

CXX="clang++-18"
CPPFLAGS="$CPPFLAGS -DODIN_VERSION_RAW=\"dev-$(date +"%Y-%m")\""
CXXFLAGS="$CXXFLAGS -std=c++14 $(llvm-config-18 --cflags)"
DISABLED_WARNINGS="-Wno-switch -Wno-macro-redefined -Wno-unused-value"
LLVM_CONFIG='llvm-config-18'

LDFLAGS="-fuse-ld=mold -static -lzstd -lz -lffi -pthread"
LDFLAGS="$LDFLAGS $($LLVM_CONFIG --link-static --ldflags --libs --system-libs)"
EXTRAFLAGS="-O2 -fPIE"

set -x

$CXX src/main.cpp src/libtommath.cpp $DISABLED_WARNINGS $CPPFLAGS $CXXFLAGS $EXTRAFLAGS -o odin $LDFLAGS

