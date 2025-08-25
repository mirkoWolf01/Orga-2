CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej3

all: $(TARGET)
	
$(TARGET): ej3.o
	$(CC) $(CFLAGS) $^ -o $@

ej3.o: ej3.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean