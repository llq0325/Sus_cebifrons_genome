rm -f all.maf
echo "##maf version=1 scoring=multiz.3" > ./_MZ_5722_head
echo "##maf version=1 scoring=roast.v3.3" > all.maf
echo "# roast.v3 - T=. E=pig ((human mouse) (dog (horse (camel ((cattle killerwhale)(SCEB pig)))))) pig.mouse.sing.maf pig.horse.sing.maf pig.dog.sing.maf pig.human.sing.maf pig.cattle.sing.maf pig.killerwhale.sing.maf pig.camel.sing.maf pig.SCEB.sing.maf all.maf" >> all.maf
cp ./_MZ_5722_head ./_MZ_5722_MZ0
cp pig.human.sing.maf ./_MZ_5722_left.maf0
cp pig.mouse.sing.maf ./_MZ_5722_right.maf0
maf_project ./_MZ_5722_left.maf0 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf0 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf0
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf0
multiz M=1  ./_MZ_5722_left.maf0 ./_MZ_5722_right.maf0 0 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ0
grep -v -h eof ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ0
cp ./_MZ_5722_head ./_MZ_5722_MZ1
cp pig.cattle.sing.maf ./_MZ_5722_left.maf1
cp pig.killerwhale.sing.maf ./_MZ_5722_right.maf1
maf_project ./_MZ_5722_left.maf1 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf1 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf1
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf1
multiz M=1  ./_MZ_5722_left.maf1 ./_MZ_5722_right.maf1 0 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ1
grep -v -h eof ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ1
cp ./_MZ_5722_head ./_MZ_5722_MZ2
grep -v eof pig.SCEB.sing.maf >> ./_MZ_5722_MZ2
rm -f ./_MZ_5722_left.maf2 ./_MZ_5722_right.maf2
mv ./_MZ_5722_MZ1 ./_MZ_5722_left.maf3
mv ./_MZ_5722_MZ2 ./_MZ_5722_right.maf3
cp ./_MZ_5722_head ./_MZ_5722_MZ3
maf_project ./_MZ_5722_left.maf3 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf3 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf3
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf3
mv ./_MZ_5722_right.maf3 ./_MZ_5722_middle.maf
mv ./_MZ_5722_left.maf3 ./_MZ_5722_right.maf3
mv ./_MZ_5722_middle.maf ./_MZ_5722_left.maf3
multiz M=1  ./_MZ_5722_left.maf3 ./_MZ_5722_right.maf3 1 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ3
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf3
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf3
mv ./_MZ_5722_MZ3 ./_MZ_5722_right.maf4
cp ./_MZ_5722_head ./_MZ_5722_MZ4
cp pig.camel.sing.maf ./_MZ_5722_left.maf4
maf_project ./_MZ_5722_left.maf4 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf4 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf4
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf4
mv ./_MZ_5722_right.maf4 ./_MZ_5722_middle.maf
mv ./_MZ_5722_left.maf4 ./_MZ_5722_right.maf4
mv ./_MZ_5722_middle.maf ./_MZ_5722_left.maf4
multiz M=1  ./_MZ_5722_left.maf4 ./_MZ_5722_right.maf4 1 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ4
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf4
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf4
mv ./_MZ_5722_MZ4 ./_MZ_5722_right.maf5
cp ./_MZ_5722_head ./_MZ_5722_MZ5
cp pig.horse.sing.maf ./_MZ_5722_left.maf5
maf_project ./_MZ_5722_left.maf5 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf5 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf5
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf5
mv ./_MZ_5722_right.maf5 ./_MZ_5722_middle.maf
mv ./_MZ_5722_left.maf5 ./_MZ_5722_right.maf5
mv ./_MZ_5722_middle.maf ./_MZ_5722_left.maf5
multiz M=1  ./_MZ_5722_left.maf5 ./_MZ_5722_right.maf5 1 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ5
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf5
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf5
mv ./_MZ_5722_MZ5 ./_MZ_5722_right.maf6
cp ./_MZ_5722_head ./_MZ_5722_MZ6
cp pig.dog.sing.maf ./_MZ_5722_left.maf6
maf_project ./_MZ_5722_left.maf6 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf6 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf6
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf6
mv ./_MZ_5722_right.maf6 ./_MZ_5722_middle.maf
mv ./_MZ_5722_left.maf6 ./_MZ_5722_right.maf6
mv ./_MZ_5722_middle.maf ./_MZ_5722_left.maf6
multiz M=1  ./_MZ_5722_left.maf6 ./_MZ_5722_right.maf6 1 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ6
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf6
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf6
mv ./_MZ_5722_MZ0 ./_MZ_5722_left.maf7
mv ./_MZ_5722_MZ6 ./_MZ_5722_right.maf7
cp ./_MZ_5722_head ./_MZ_5722_MZ7
maf_project ./_MZ_5722_left.maf7 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
maf_project ./_MZ_5722_right.maf7 pig ./_MZ_5722_O2 > ./_MZ_5722_U2
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf7
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf7
mv ./_MZ_5722_right.maf7 ./_MZ_5722_middle.maf
mv ./_MZ_5722_left.maf7 ./_MZ_5722_right.maf7
mv ./_MZ_5722_middle.maf ./_MZ_5722_left.maf7
multiz M=1  ./_MZ_5722_left.maf7 ./_MZ_5722_right.maf7 1 ./_MZ_5722_U1 ./_MZ_5722_U2 >> ./_MZ_5722_MZ7
mv ./_MZ_5722_U1 ./_MZ_5722_left.maf7
mv ./_MZ_5722_U2 ./_MZ_5722_right.maf7
maf_project ./_MZ_5722_MZ7 pig ./_MZ_5722_O1 > ./_MZ_5722_U1
grep -v eof ./_MZ_5722_U1 >> all.maf
#rm ./_MZ_5722_*
echo "##eof maf" >> all.maf
