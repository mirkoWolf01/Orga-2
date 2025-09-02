CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ej*

all: $(TARGET)
	
$(TARGET): $(TARGET).o
	$(CC) $(CFLAGS) $^ -o $@
	rm *.o

$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) -c $< -o $@
	
clean:
		rm *.o $(TARGET)

