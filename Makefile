all: build
clean: 
	rm -rfv .dist
build: clean
	mkdir -pv .dist
	
	tar czvf .dist/chi-bin.tar.gz -C ./cmds .