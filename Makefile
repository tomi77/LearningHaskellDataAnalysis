default_target: all

.PHONY : default_target

all: median

median: median.hs
	mkdir -p bin
	ghc $< -o bin/$@
	rm -f *.hi *.o
