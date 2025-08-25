CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej8

all: $(TARGET)
	
$(TARGET): ej8.o
	$(CC) $(CFLAGS) $^ -o $@

ej8.o: ej8.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean