.ONESHELL:

CC=clang++
BUILD=.build

SRC=src
MAIN_SRC=${SRC}/main
STATIC_LIBS:=slib
DYNAMIC_LIBS:=dlib

STATIC_LIBS_OBJS:=$(STATIC_LIBS:%=${BUILD}/%.o)
DYNAMIC_LIBS_OBJS:=$(DYNAMIC_LIBS:%=${BUILD}/shared/lib%.so)

main: ${MAIN_SRC}/main.cpp ${STATIC_LIBS_OBJS} ${DYNAMIC_LIBS_OBJS}
	LD_LIBRARY_PATH=${BUILD}/shared ${CC} $< ${STATIC_LIBS_OBJS} -I${SRC} -L${BUILD}/shared/ $(DYNAMIC_LIBS:%=-l%) -o ${BUILD}/main

run: main
	./${BUILD}/main

${BUILD}/%.o: ${SRC}/%/*.cpp ${BUILD}
	${CC} -c $< -o $@

${BUILD}/shared/lib%.so: ${SRC}/%/*.cpp ${BUILD}/shared
	${CC} -fPIC -shared $< -o $@

.PHONY: clean

${BUILD}:
	mkdir -p $@

${BUILD}/shared:
	mkdir -p $@

clean:
	rm -rf ${BUILD}/*
