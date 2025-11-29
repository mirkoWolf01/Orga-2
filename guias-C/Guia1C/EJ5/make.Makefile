CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej5

all: $(TARGET)
	
$(TARGET): ej5.o
	$(CC) $(CFLAGS) $^ -o $@

ej5.o: ej5.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean