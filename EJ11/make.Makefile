CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej11

all: $(TARGET)
	
$(TARGET): ej11.o
	$(CC) $(CFLAGS) $^ -o $@

ej11.o: ej11.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean