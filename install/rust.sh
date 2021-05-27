#!/usr/bin/env bash

echo "install rustup, cargo"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "install useful cargo extensions"
cargo install cargo-edit cargo-watch

echo "install rustfmt (formatter), clippy (linter), rls (language server)"
rustup component add rustfmt clippy rls
