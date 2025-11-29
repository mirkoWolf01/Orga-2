CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej7

all: $(TARGET)
	
$(TARGET): ej7.o
	$(CC) $(CFLAGS) $^ -o $@

ej7.o: ej7.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean