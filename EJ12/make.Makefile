CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej12

all: $(TARGET)
	
$(TARGET): ej12.o
	$(CC) $(CFLAGS) $^ -o $@

ej12.o: ej12.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean