CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej1

all: $(TARGET)
	
$(TARGET): ej1.o
	$(CC) $(CFLAGS) $^ -o $@

ej1.o: ej1.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean