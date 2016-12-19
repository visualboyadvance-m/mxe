# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cloog
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.3
$(PKG)_CHECKSUM := 460c6c740acb8cdfbfbb387156b627cf731b3837605f2ec0001d079d89c69734
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.bastoul.net/cloog/pages/download/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := gcc gmp isl

$(PKG)_DEPS_$(BUILD) := gmp isl

# stick to tested versions from gcc
# after gcc4 series, switch to normal updates and bundled isl
define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://gcc.gnu.org/pub/gcc/infrastructure/' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)' \
        --program-suffix=-isl
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
