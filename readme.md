


```sh
cd ~/bitcoin-build
git clone https://github.com/miniupnp/miniupnp.git
cd miniupnp/miniupnpc
make -f Makefile.mingw
mkdir -p $HOME/bitcoin-build/miniupnpc-install
cp *.h $HOME/bitcoin-build/miniupnpc-install
cp *.a $HOME/bitcoin-build/miniupnpc-install

```

```sh
export MINIUPNP_PREFIX=$HOME/bitcoin-build/miniupnpc-install
export CPPFLAGS="$CPPFLAGS -I$MINIUPNP_PREFIX"
export LDFLAGS="$LDFLAGS -L$MINIUPNP_PREFIX"
```
