# inspired by: https://github.com/joaocarvalhoopen/fastDTW_in_Odin__Fast_Dynamic_Time_Warping/blob/main/Makefile


all:
	odin build . -out:./bin/syndatagen.exe --debug

opti:
	odin build . -out:./bin/syndatagen.exe -o:speed -no-bounds-check -disable-assert
	# odin build . -out:./bin/syndatagen.exe -o:aggressive -microarch:native -no-bounds-check -disable-assert

clean:
	rm ./bin/syndatagen.exe

run:
	./bin/syndatagen.exe example_parameter.json
