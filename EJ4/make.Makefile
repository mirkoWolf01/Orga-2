CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej4

all: $(TARGET)
	
$(TARGET): ej4.o
	$(CC) $(CFLAGS) $^ -o $@

ej4.o: ej4.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean