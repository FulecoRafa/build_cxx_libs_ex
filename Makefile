.ONESHELL:

CC=clang++
BUILD=.build

SRC=src
MAIN_SRC=${SRC}/main
STATIC_LIBS:=slib
DYNAMIC_LIBS=dlib

STATIC_LIBS_OBJS:=$(STATIC_LIBS:%=${BUILD}/%.o)
DYNAMIC_LIBS_OBJS:=$(DYNAMIC_LIBS:%=${BUILD}/shared/%.so)

main: ${MAIN_SRC}/main.cpp ${STATIC_LIBS_OBJS} ${DYNAMIC_LIBS_OBJS} ${BUILD}
	${CC} $< ${STATIC_LIBS_OBJS} -I${SRC} -L${BUILD}/shared -o ${BUILD}/main

run: main
	./${BUILD}/main

${BUILD}/%.o: ${SRC}/%/*.cpp ${BUILD}
	${CC} -c $< -o $@

${BUILD}/shared/%.so: ${SRC}/%/*.cpp ${BUILD}
	${CC} -shared $< -o $@

.PHONY: ${BUILD} clean
${BUILD}:
	mkdir ${BUILD} || true
	mkdir ${BUILD}/shared || true

clean:
	rm -rf ${BUILD}/*
