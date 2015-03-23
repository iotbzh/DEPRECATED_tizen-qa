SRC=logo.png

all: icon_144.png icon_114.png icon_72.png icon_57.png favicon.ico

icon_144.png: $(SRC)
	convert $< -resize 144 $@

icon_114.png: $(SRC)
	convert $< -resize 114 $@

icon_72.png: $(SRC)
	convert $< -resize 72 $@

icon_57.png: $(SRC)
	convert $< -resize 57 $@

favicon.ico: favicon.png
	convert $< -resize 16x16 $@

.PHONY: clean
clean:
	rm -f icon_144.png icon_114.png icon_72.png icon_57.png favicon.ico
