#! /bash/bin

echo "--------------------URL---START-----------------------"

filetxt="./file.txt"

if [ -f $filetxt ]; then
	rm $filetxt
fi

	
for i in `cat url.txt`
do
	find ./src/htjs/web -iname "$i*.java" >> file.txt
done

cat file.txt

echo "---------------------URL---END-----------------------"

echo "---------------------FILE---START-----------------------"

for i in `cat file.txt`
do
	lineNum=`sed -n '/private.*up/=' $i`
	let "lineNum += 1"
	l=`sed -n '/private.*up/p' $i`
	sed -i "/private.*up/a\\$l" $i
	sed -i "${lineNum}s/up/CXDY/" $i

	echo "--------------------$i----------------------------"

	beanNum=`sed -n '/JsonHelp.getBean(.*[uU]p/=' $i`
	let "beanNum += 1"
	beanL=`sed -n '/JsonHelp.getBean(.*[uU]p/p' $i`
	sed -i "/JsonHelp.getBean(.*[uU]p/a\\${beanL}" $i
	sed -i "${beanNum}s/[uU]p/CXDY/g" $i

	touch temp
	echo $l > temp
	echo `cut -f3 -d' ' temp` > temp
	sed -i 's/[uU]p;//g' temp
	class=`cat temp`
	
	mapLine=`sed -n '/Map retMap = .*/p' $i`
	echo $mapLine
	line=${mapLine#*Map}
	echo "line=${line}"
	line_1=${line/$class/${class}CXDY}
	echo "line_1=${line_1}"
	rep="	Map retMap; \n 	if(HelpTools.isFromCxk(mapParam)) ${line_1} \n 	else ${line}"

	echo "rep=${rep}"	
	mapNum=`sed -n '/Map retMap = .*/=' $i`
	echo "mapNum=${mapNum}"
	sed -i "/Map retMap = .*/a\\${rep}" $i
	sed -i "${mapNum}d" $i
done

echo "---------------------FILE---END-----------------------"


