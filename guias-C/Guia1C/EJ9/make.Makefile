CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej9

all: $(TARGET)
	
$(TARGET): ej9.o
	$(CC) $(CFLAGS) $^ -o $@

ej9.o: ej9.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
		rm *.o $(TARGET)

.PHONY: all clean