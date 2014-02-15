if [ ! -d orig ]; then
	echo Please first run make.sh on the original .s files, create
	echo the directory \"orig\", and copy all .bin files from \"tmp\"
	echo into \"orig\".
	exit;
fi

for i in cbmbasic1 cbmbasic2 kbdbasic osi kb9 applesoft microtan aim65 sym1; do

echo $i
ca65 -D $i msbasic.s -o tmp/$i.o &&
ld65 -C $i.cfg tmp/$i.o -o tmp/$i-new.bin -Ln tmp/$i.lbl && 
xxd -g 1 orig/$i.bin > tmp/$i.bin.txt
xxd -g 1 tmp/$i-new.bin > tmp/$i-new.bin.txt
diff -u tmp/$i.bin.txt tmp/$i-new.bin.txt | head

done
