# WARNING: This is firstly made to be run in linux.
# Probably works in MacOS.
# Will NOT work in windows, unless using GNU tooling.

# By default, Makefile will run each command in its own subshell.
# This prevents that
.ONESHELL:

# Name of the compiler to be used. This is default, but can be changed by
# setting it when calling make. Ex: `CC=g++ make`
CC=clang++
# Same thing as compiler, but for output/build folder.
BUILD=.build

# This section of variables are prefered to be set directly in the file.
# They dictate how the C project should be organized
# SRC is where all files should be
SRC=src
# MAIN is the executable being built
MAIN_SRC=${SRC}/main
# List of libs that will be statically compiled and linked
STATIC_LIBS:=slib
# List of custom dynamic lib. This does not include builtin shared lib ex: libm
DYNAMIC_LIBS:=dlib

# This is the section of calculated variables.
# Allows us to change from variables set by tha user
STATIC_LIBS_OBJS:=$(STATIC_LIBS:%=${BUILD}/%.o)
DYNAMIC_LIBS_OBJS:=$(DYNAMIC_LIBS:%=${BUILD}/shared/lib%.so)

# Main target. Depends on all libraries and the main files (in this case, one)
main: ${MAIN_SRC}/main.cpp ${STATIC_LIBS_OBJS} ${DYNAMIC_LIBS_OBJS}
	${CC} $< ${STATIC_LIBS_OBJS} -I${SRC} -L${BUILD}/shared/ $(DYNAMIC_LIBS:%=-l%) -o ${BUILD}/main

# Autoruns program after compile
run: main
	./${BUILD}/main

# Any static library (ends in .o) and how it will build.
# By default, asume all cpp files in src/lib folder are parts of the 
# resulting object.
#
# OBS:
# 	- % will match anything on target and repeat the match anywhere in dependencies
# 		or instructions.
# 	- $< is the first dependency
# 	- $@ is the target (before `:`)
${BUILD}/%.o: ${SRC}/%/*.cpp ${BUILD}
	${CC} -c $< -o $@

# Any dynamic library (ends in .so) and how it will build.
# By default, asume all cpp files in src/lib folder are parts of the 
# resulting object.
${BUILD}/shared/lib%.so: ${SRC}/%/*.cpp ${BUILD}/shared
	${CC} -fPIC -shared $< -o $@

# Makefile will not run targets if results may exist.
# PHONY garantees these rules are not cached and will always run.
.PHONY: clean


# Creates build directory.
${BUILD}:
	mkdir -p $@

# Creates build directory for shared libraries.
${BUILD}/shared:
	mkdir -p $@

# Drops build directory entirelly
clean:
	rm -rf ${BUILD}/*
