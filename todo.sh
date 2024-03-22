#! /bin/env bash 

function show1 {
        if [ -z "$1" ];then
		echo "$(awk -F ',' '{print NR" | "$1" | "$2" | "$3}' "tasks.csv")"
        else
		echo $1
		echo "$(echo $1 |awk -F ',' '{print NR" | "$1" | "$2" | "$3}')"

        fi
}

if [ $1 = "add" ];then
       shift
       title=""
       priority=""
       while [ -n "$1" ];do
               if ( [ "$1" = "-t" ] || [ "$1" = "--title" ] ) && [ -z "$title" ];then
                        shift
                        if [ -n "$1" ];then
                                title=$1
                                shift
                        else
                                echo "Option -t|--title Needs a Parameter"i
				exit 1
                        fi
                elif ( [ "$1" = "-p" ] || [ "$1" = "--priority" ] ) && [ -z "$priority" ];then
                        shift
                        if [ -n "$1" ] && ( [ "$1" = "H" ] || [ "$1" = "M" ] || [ "$1" = "L" ] );then
                                priority=$1
                                shift
                        else
                                echo "Option -p|--priority Only Accept L|M|H"
                                exit 1
                        fi
                else
                        echo "add command format is wrong"
                        exit 1

                fi

       done
        if [ -z "$title" ];then
		echo "Option -t|--title Needs a Parameter"
		exit 1

	fi 	
        if [ -z "$priority" ];then
                priority="L"
        fi
        if [ ! -f 'tasks.csv' ] ;then
                touch 'tasks.csv'
        fi

        echo "0,$priority,\"$title\"" >> tasks.csv

elif [ $1 = "clear" ];then
	if [ -f 'tasks.csv' ] ;then
		rm -f "tasks.csv"
                touch "tasks.csv"
        fi

elif [ $1 = "list" ];then
        if [  -f 'tasks.csv' ] ;then
		echo "$(show1)" 
        fi

elif [ $1 = "find" ];then
	shift
	if [  -f 'tasks.csv' ] ;then
		result=$(grep  $1 tasks.csv)
		if [ -n "$result" ];then
			grep $1 tasks.csv |awk -F ',' '{print NR" | "$1" | "$2" | "$3}'| echo "$(cat)"
			exit 0
cho "$(cat)"	
		fi
        fi
elif [ $1 = "done" ];then
        shift
	if [  -f 'tasks.csv' ] ;then
		num_lines=$(wc -l "tasks.csv" | cut -d ' ' -f1)
		if [ $1 -gt $num_lines ]; then
   			 echo "Line number '$1' exceeds the number of lines in the CSV file."
    			 exit 1
		fi
		sed -i "$1s/^0/1/" "tasks.csv"
	fi
else 
	echo "Command Not Supported!"
	exit 1 
fi

