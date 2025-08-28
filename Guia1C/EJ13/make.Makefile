CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej13

all: $(TARGET)
	
$(TARGET): ej13.o
	$(CC) $(CFLAGS) $^ -o $@

ej13.o: ej13.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean