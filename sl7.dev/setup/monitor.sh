#new added
read -p "Confirmed ? (Y/N): " yn

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then

echo " total number of machine e.g. 2 db and 2 web =4 "
read nm

echo "Pls enter Name of the Game e.g. island "
read nn

rm -rf /tmp/filefile
for ((i=1; i<=$nm; i++));
do
echo "Pls enter FQDN  e.g. db1.6waves.com" && read hm&& echo "sed -$hm >> /tmp/filefile;
done



echo  "\"$nn\"  => array ( " >> /tmp/filefile


elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
        echo "Oh, interrupt!"
else
        echo "script will be exist " && exit 0
fi


sed -i 's/^/sed -i 228a\\g' /tmp/filefile


