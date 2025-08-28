CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej15

all: $(TARGET)
	
$(TARGET): ej15.o
	$(CC) $(CFLAGS) $^ -o $@

ej15.o: ej15.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean