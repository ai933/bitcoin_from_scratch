#!/usr/bin/env bash
set -e

# مجلد العمل
mkdir -p $HOME/bitcoin-build && cd $HOME/bitcoin-build

# ========= OpenSSL 1.0.2u =========
if [ ! -d "openssl-1.0.2u" ]; then
  curl -LO https://www.openssl.org/source/openssl-1.0.2u.tar.gz
  tar xf openssl-1.0.2u.tar.gz
fi
cd openssl-1.0.2u
./Configure mingw64 no-shared --prefix=$HOME/bitcoin-build/openssl-1.0
make -j$(nproc)
make install
cd ..

export OPENSSL_PREFIX=$HOME/bitcoin-build/openssl-1.0
export CPPFLAGS="-I$OPENSSL_PREFIX/include"
export LDFLAGS="-L$OPENSSL_PREFIX/lib"
export PATH="$OPENSSL_PREFIX/bin:$PATH"

# ========= Berkeley DB 4.8 =========
if [ ! -d "db-4.8.30.NC" ]; then
  curl -LO http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
  tar xf db-4.8.30.NC.tar.gz
fi
cd db-4.8.30.NC/build_unix
../dist/configure --prefix=$HOME/bitcoin-build/db4 --enable-mingw --enable-cxx
make -j$(nproc)
make install
cd ../..

export BDB_PREFIX=$HOME/bitcoin-build/db4
export CPPFLAGS="$CPPFLAGS -I$BDB_PREFIX/include"
export LDFLAGS="$LDFLAGS -L$BDB_PREFIX/lib"

# ========= miniupnpc 1.9 =========
if [ ! -d "miniupnpc-1.9" ]; then
  curl -LO http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.9.tar.gz -o miniupnpc-1.9.tar.gz
  tar xf miniupnpc-1.9.tar.gz
fi
cd miniupnpc-1.9
make -f Makefile.mingw
mkdir -p $HOME/bitcoin-build/miniupnpc
cp *.h $HOME/bitcoin-build/miniupnpc
cp *.a $HOME/bitcoin-build/miniupnpc
cd ..

export MINIUPNP_PREFIX=$HOME/bitcoin-build/miniupnpc
export CPPFLAGS="$CPPFLAGS -I$MINIUPNP_PREFIX"
export LDFLAGS="$LDFLAGS -L$MINIUPNP_PREFIX"

# ========= Bitcoin Core 0.10.0 =========
if [ ! -d "bitcoin" ]; then
  git clone https://github.com/bitcoin/bitcoin.git
fi
cd bitcoin
git fetch --tags
git checkout v0.10.0
./autogen.sh
./configure \
  --with-gui=no \
  --with-boost=yes \
  --with-miniupnpc=yes \
  --disable-tests \
  --disable-bench \
  CPPFLAGS="$CPPFLAGS" \
  LDFLAGS="$LDFLAGS"
make -j$(nproc)

echo "✅ تم البناء بنجاح!"
echo "تجد البرامج في: ~/bitcoin-build/bitcoin/src/"
echo "شغّل: ./src/bitcoind --version"
