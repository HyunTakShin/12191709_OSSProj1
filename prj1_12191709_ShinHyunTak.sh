#! /bin/bash
echo "--------------------------------"
echo "User Name: Shin Hyun Tak"
echo "Student Number: 12191709"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.item'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 'occupation' and 'programmer'"
echo "9. Exit"
echo "--------------------------------"
n=0
until  [ $n = 9 ]
do 
	read -p "Enter your choice [1-9] " n
	case $n in
	1)
		read -p "Please enter the 'movie id'(1~1682):" id
		cat ./u.item|awk -v c=$id -F '|' '$1==c {print}'
		;;
	2)
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'(y/n)" res
		case $res in
		'y')
			cat ./u.item|awk -v c=$count -F '|' '$7==1 && count++<10 {printf("%s %s\n", $1, $2)}'
		esac
		;;
	3)
		read -p "Please enter the 'movie id'(1~1682):" id
		cat ./u.data|awk -v mid=$id '$2==mid {sum+=$3;count++} END {printf("average rating of %s: %.5f\n", mid, sum/count)}'
		;;
	4)
		read -p "Do you want to delete the 'IMDb URL' from' u.item?(y/n)'" res 
		case $res in
		'y')
			cat u.item|sed -E 's/\|http.*\)//g'|sed -n '1,10p'
		esac
		;;
	5)
		read -p "Do you want to get the data about users from 'u.user'?(y/n)" res
		case $res in
		'y')
			cat u.user|awk -F\| '{printf("user %s is %s years old %s %s\n",$1,$2,$3,$4)}'|sed -n '1,10p'
		esac
		;;
	6)
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n)" res
		case $res in
		'y')
			cat u.item|sed -E 's/-Jan-/01/;s/-Feb-/02/;s/-Mar-/03/;s/-Apr-/04/;s/-May-/05/;s/-Jun-/06/;s/-Jul-/07/;s/-Aug-/08/;s/-Sep-/09/;s/-Oct-/10/;s/-Nov-/11/;s/-Dec-/12/'|sed -E -e 's/([0-9][0-9])([0-9][0-9])([0-9][0-9][0-9][0-9])/\3\2\1/' |sed -n '1673,1682p'
		esac
		;;
	7)
		read -p "Please enter the 'user id'(1~943): " id
		awk -v id=$id '$1==id{printf("%d\n",$2)}' ./u.data|sort -n| tr '\n' '|' > a.txt
		awk '{print}' ./a.txt
		count=1
		while [ $count -le 10 ]
		do
			b=$(awk -v cnt=$count -F\| '{printf("%s",$cnt)}' ./a.txt)
			cat u.item|awk -v comp=$b -F\| 'comp==$1{printf("%s|%s\n",$1,$2)}'
			let count=count+1
		done
		;;
	8) 
		read -p  "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(Y/N):" res
		case $res in
		y)
			usrtemp=$(awk -F\| '$2<=29 && $2>=20 && $4=="programmer" {printf("%s ", $1)}' ./u.user)
			movtemp=$(awk -F\| '{printf("%s ",$1)}' ./u.item)
			for var1 in $movtemp
			do
				count=0
				sum=0
				for var2 in $usrtemp
				do
					temps=$(awk -v uid=$var2 -v mid=$var1 '$1==uid && $2==mid{printf("%d",$3)}' ./u.data)
					tempc=$(awk -v uid=$var2 -v mid=$var1 '$1==uid && $2==mid{printf("%d",1)}' ./u.data)
					sum=$((sum+temps))
					count=$((count+tempc))
				done
				case $count in
				0)
					;;
				*)
					echo $var1 $sum $count |awk '{printf("%d %.5f\n",$1,$2/$3)}'
				esac
			done
		esac
		;;
	9) 
		echo "Bye!";;
	*) 
		echo "Wrong input!";;
	esac	
done
