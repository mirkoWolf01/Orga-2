CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej10

all: $(TARGET)
	
$(TARGET): ej10.o
	$(CC) $(CFLAGS) $^ -o $@

ej10.o: ej10.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean