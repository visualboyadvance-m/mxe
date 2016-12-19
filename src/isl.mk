# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := isl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.16.1
$(PKG)_CHECKSUM := 45292f30b3cb8b9c03009804024df72a79e9b5ab89e41c94752d6ea58a1e4b02
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://isl.gforge.inria.fr/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := gcc gmp

$(PKG)_DEPS_$(BUILD) := gmp

# stick to tested versions from gcc
# while in gcc4 series specific versions are required:
# http://web.archive.org/web/20141031011459/http://gcc.gnu.org/install/prerequisites.html
define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://gcc.gnu.org/pub/gcc/infrastructure/' | \
    $(SED) -n 's,.*isl-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
