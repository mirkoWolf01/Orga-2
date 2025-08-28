CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej16

all: $(TARGET)
	
$(TARGET): ej16.o
	$(CC) $(CFLAGS) $^ -o $@

ej16.o: ej16.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean