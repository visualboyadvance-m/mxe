# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.9
$(PKG)_CHECKSUM := 03d9c7f67976cf1389589782de46f45011053ea7f4222c2fb8c2cf9fd813bb68
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://zlib.net/$($(PKG)_FILE)
$(PKG)_URL_2    := http://$(SOURCEFORGE_MIRROR)/project/libpng/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

define $(PKG)_BUILD_SHARED
    $(MAKE) -C '$(1)' -f win32/Makefile.gcc \
        SHARED_MODE=1 \
        STATICLIB= \
        BINARY_PATH='$(PREFIX)/$(TARGET)/bin' \
        INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        LIBRARY_PATH='$(PREFIX)/$(TARGET)/lib' \
        PREFIX='$(TARGET)-' \
        -j '$(JOBS)' install
endef
