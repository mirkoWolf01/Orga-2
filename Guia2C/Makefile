CC = gcc
CFLAGS = -g -Wall -Wextra -pedantic
TARGET = algo

all: $(TARGET)
	
$(TARGET): $(TARGET).o
	$(CC) $(CFLAGS) $^ -o $@
	rm *.o 

$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) -c $< -o $@
	
clean:
		rm $(TARGET)

