OBJS = mock.o
SOURCE = mock.s
OUT = mock

MASM = nasm
MASM_F = -felf32 -g -Fdwarf
LD = ld
LD_F = -melf_i386

all:$(OBJS)
	$(LD) $(LD_F) $(OBJS) -o $(OUT)

mock.o:mock.s
	$(MASM) $(MASM_F) mock.s -o mock.o

clean:
	rm -f $(OBJS) $(OUT)
