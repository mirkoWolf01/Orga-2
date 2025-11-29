CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej14

all: $(TARGET)
	
$(TARGET): ej14.o
	$(CC) $(CFLAGS) $^ -o $@

ej14.o: ej14.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean