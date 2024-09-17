.ONESHELL:

CC=clang++

SRC=src
MAIN_SRC=${SRC}/main
STATIC_LIB=slib
STATIC_LIB_SRC=${SRC}/${STATIC_LIB}
DYNAMIC_LIB=dlib
DYNAMIC_LIB_SRC=${SRC}/${DYNAMIC_LIB}

BUILD=.build

main: ${MAIN_SRC}/main.cpp ${BUILD}/${STATIC_LIB}.o ${BUILD}/shared/${DYNAMIC_LIB}.so ${BUILD}
	${CC} $< ${BUILD}/${STATIC_LIB}.o -I${SRC} -L${BUILD}/shared -o ${BUILD}/main

run: main
	./${BUILD}/main

${BUILD}/${STATIC_LIB}.o: ${STATIC_LIB_SRC}/${STATIC_LIB}.cpp ${BUILD}
	${CC} -c $< -o ${BUILD}/${STATIC_LIB}.o

${BUILD}/shared/${DYNAMIC_LIB}.so: ${DYNAMIC_LIB_SRC}/${DYNAMIC_LIB}.cpp ${BUILD}
	${CC} -shared $< -o ${BUILD}/shared/${DYNAMIC_LIB}.so

.PHONY: ${BUILD} clean
${BUILD}:
	mkdir ${BUILD} || true
	mkdir ${BUILD}/shared || true

clean:
	rm -rf ${BUILD}/*
