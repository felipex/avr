# Tem como propósito a compilação e gravação automatizada de códigos feitos para ATmega
# Usado para gravar códigos de ATmega diretamente no Arduino
#
# Copyright (C) 2018 ADA-Projetos em Engenharia de Computacao
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Pedro V. B. Jeronymo (pedrovbj@gmail.com)
#
NAME=main
CFLAGS=-Os -DF_CPU=$(CPU_F)
MICRO=328p
CPU_F=16000000
OBJ = main.o

all: exe
	avr-objcopy -O ihex -R .eeprom $(NAME).out $(NAME).hex

exe: $(OBJ)
	avr-gcc -mmcu=atmega$(MICRO) $(OBJ) -o $(NAME).out

%.o: %.c
	avr-gcc -c -o $@ $< $(CFLAGS) -std=c11 -mmcu=atmega$(MICRO)

upload: all
	avrdude -v -c arduino -p m$(MICRO) -P /dev/ttyUSB0 -b 115200 -U flash:w:$(NAME).hex

clean:
	rm $(NAME).out
	rm *.o
	rm $(NAME).hex