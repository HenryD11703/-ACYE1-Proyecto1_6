aarch64-linux-gnu-as -o programa.o programa.s
aarch64-linux-gnu-ld -o programa programa.o
qemu-aarch64 ./programa


