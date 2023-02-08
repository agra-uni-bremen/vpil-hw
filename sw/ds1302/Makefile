OBJECTS = main.o DS1302.o arduino_wrapper.o
CXXFLAGS = -std=c++14 #-fno-exceptions -fno-use-cxa-atexit -Wabi-tag -D_GLIBCXX_USE_CXX11_ABI=0
CFLAGS =
COMMON_OBJECTS = ../common/irq.o
include ../Makefile.common
override LD=$(CXX)