CC = g++
INCLUDES = -I /usr/local/boost_1_64_0
LIB_DIR = -L /usr/local/boost_1_64_0/stage/lib
LIBRARIES = -lboost_system -lboost_filesystem
OBJS = HW2.2.o

all: ${OBJS}
	LD_LIBRARY_PATH=/usr/local/boost_1_64_0/stage/lib ${CC} ${OPTIONS} ${OBJS} -o HW2.2 ${LIB_DIR} ${LIBRARIES}

%.o: %.cpp
	LD_LIBRARY_PATH=/usr/local/boost_1_64_0/stage/lib ${CC} -std=c++14 ${OPTIONS} -c $*.cpp ${INCLUDES}

clear:
	rm -rf *.o
	rm HW2.2
