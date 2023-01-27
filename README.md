# Individuwill Vault-cgo

This formula is a copy from [vault.rb](https://github.com/Homebrew/homebrew-core/blob/ebae02f411aa5dcd505e9f13649e4eb0b5708ec0/Formula/vault.rb) in the homebrew-core repo.

It has been modified so that it is installed from source only (no bottles) and has the option to compile with the cgo DNS resolver. This may be required for a number of different reasons, but I needed it as it didn't play nice with some DNS intercept software unless compiled this way.

> Note that compilation will take 5-15 minutes. Total installation may take 20-30.


## How do I install these formulae?

You will first need to uninstall your existing vault formula if it's installed. `brew uninstall vault`.

Then install the tap `brew tap individuwill/tap` and then the formula with the cgo flag `brew install vault-cgo --with-netcgo`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
