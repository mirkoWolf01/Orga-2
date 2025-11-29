CC = gcc
CFLAGS = -Wall -Wextra -pedantic -g
TARGET = main

SRCS = main.c list.c type.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)
	rm $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm $(TARGET)

.PHONY: all clean
