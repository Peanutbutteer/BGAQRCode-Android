#
# Android NDK makefile 
#
# build - <ndk path>/ndk-build ICONV_SRC=<iconv library src> 
# clean -  <ndk path>/ndk-build clean
#
MY_LOCAL_PATH := $(call my-dir)

# libiconv
include $(CLEAR_VARS)
ICONV_SRC := $(MY_LOCAL_PATH)/libiconv-1.15
LOCAL_PATH := $(ICONV_SRC)

LOCAL_MODULE := iconv # Changed to 'iconv' as 'libiconv' will have 'lib' prefix added by build system

LOCAL_CFLAGS := \
    -Wno-multichar \
    -D_ANDROID \
    -DLIBDIR="c" \
    -DBUILDING_LIBICONV \
    -DBUILDING_LIBCHARSET \
    -DIN_LIBRARY

LOCAL_SRC_FILES := \
    lib/iconv.c \
    libcharset/lib/localcharset.c \
    lib/relocatable.c

LOCAL_C_INCLUDES := \
    $(ICONV_SRC)/include \
    $(ICONV_SRC)/libcharset \
    $(ICONV_SRC)/libcharset/include

# Linker flags for page size alignment should be in LOCAL_LDFLAGS, not LOCAL_CFLAGS.
# Adding both max-page-size and common-page-size for 16KB alignment.
LOCAL_LDFLAGS += "-Wl,-z,max-page-size=16384"
LOCAL_LDFLAGS += "-Wl,-z,common-page-size=16384"

include $(BUILD_SHARED_LIBRARY)

# LOCAL_LDLIBS is typically used for linking against prebuilt libraries or system libraries.
# If 'charset' is another module you are building, you should use LOCAL_SHARED_LIBRARIES.
# Assuming -llog and -lcharset are intended for system libraries.
LOCAL_LDLIBS := -llog -lcharset

# libzbarjni
include $(CLEAR_VARS)

LOCAL_PATH := $(MY_LOCAL_PATH)
LOCAL_MODULE := zbarjni
LOCAL_SRC_FILES := zbarjni.c \
           zbar/img_scanner.c \
           zbar/decoder.c \
           zbar/image.c \
           zbar/symbol.c \
           zbar/convert.c \
           zbar/config.c \
           zbar/scanner.c \
           zbar/error.c \
           zbar/refcnt.c \
           zbar/video.c \
           zbar/video/null.c \
           zbar/decoder/code128.c \
           zbar/decoder/code39.c \
           zbar/decoder/code93.c \
           zbar/decoder/codabar.c \
           zbar/decoder/databar.c \
           zbar/decoder/ean.c \
           zbar/decoder/i25.c \
           zbar/decoder/qr_finder.c \
           zbar/qrcode/bch15_5.c \
           zbar/qrcode/binarize.c \
           zbar/qrcode/isaac.c \
           zbar/qrcode/qrdec.c \
           zbar/qrcode/qrdectxt.c \
           zbar/qrcode/rs.c \
           zbar/qrcode/util.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
            $(LOCAL_PATH)/zbar \
            $(ICONV_SRC)/include

# Ensure zbarjni links against the iconv module you just built.
# The module name is 'iconv' as defined above (LOCAL_MODULE := iconv).
LOCAL_SHARED_LIBRARIES := iconv

# Adding both max-page-size and common-page-size for 16KB alignment.

ifeq ($(filter $(TARGET_ARCH_ABI), arm64-v8a x86_64), arm64-v8a x86_64)
    LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384
    LOCAL_LDFLAGS += -Wl,-z,common-page-size=16384
endif

include $(BUILD_SHARED_LIBRARY)
