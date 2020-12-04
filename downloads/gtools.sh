#!/usr/local/bin/bash

# add source
brew tap homebrew/dupes

# GNU Coreutils
brew install coreutils

# build tools
brew install autoconf
brew install m4
brew install make

# misc
brew install binutils
brew install diffutils
brew install ed --default-names
brew install findutils --default-names
brew install gawk
brew install gnu-indent --default-names
brew install gnu-sed --default-names
brew install gnu-tar --default-names
brew install gnu-which --default-names
brew install gnutls --default-names
brew install grep --default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget

# third party 
brew install git
brew install less
brew install openssh --with-brewed-openssl
brew install python3 --with-brewed-openssl
brew install rsync
brew install unzip
brew install vim --override-system-vi
