#!/bin/bash

loop="1"
if [[ -n $(./test_errors.sh | grep fail) ]]; then
    ./test_errors.sh
    loop="0"
fi

testNum=0
longer_num1=0
longer_num2=0
longer_num3=0
longer_num5=0
longer_num7=0
longer_num10=0
longer_num20=0
longer_num50=0
longer_num100=0
longer_num500=0
size=1
sing=0
ran_sign=0
while [[ "$loop" == "1" ]]; do
    clear
    num=$RANDOM
    ran_sign=$RANDOM
    echo "longer moves = 1=$longer_num1 2=$longer_num2 3=$longer_num3 5=$longer_num5 7=$longer_num7 10=$longer_num10 20=$longer_num20 50=$longer_num50 100=$longer_num100 500=$longer_num500"
    echo -n "$num " > "$size".txt
    ((testNum++))
    echo "Test number $testNum"
    echo "Try sort $size number" 
    while [[ $(wc -w < "$size".txt) -lt "$size" ]]; do
        ((sing++))
        num=$RANDOM
        ran_sign=$RANDOM        
        if ! grep -q "$num" "$size".txt; then
            if (( ran_sign % sing == 0 )); then
                echo -n "-" >> "$size".txt
            fi
            echo -n "$num " >> "$size".txt
        fi
        if (( sing == 7 )); then
            sing=0
        fi
    done
    echo >> "$size".txt

    mv=""
    moves=0
    checker=ok
    while IFS= read -r nums;
    do

        if (( size != 500 )); then
            valgrind ./push_swap $nums 2> valgrind.txt > a.txt
        fi
        if (( $(cat "valgrind.txt" | grep "no leaks" | wc -l) != 1)); then
            loop=0
            cat "valgrind.txt"
            break
        fi
        if (( $(cat "valgrind.txt" | grep " 0 errors" | wc -l) != 1)); then
            loop=0
            cat "valgrind.txt"
            break
        fi
        echo -e "\e[32m===> $nums <===\e[0m"
        mv=$(./push_swap $nums )
        moves=$(echo $mv | sed 's/ /\n/g' | wc -l)
        echo -n "$moves " | awk '{print $0 " move"}'
        checker=$(./push_swap $nums | ./checker_linux $nums)
        echo "$checker"
        echo -e "============================"
    done < "$size".txt
    if [[ $checker != "OK" ]]; then
        echo $(cat "$size".txt) > KO.txt
        loop=0
        break
    fi
    if (( size == 1 )); then
        if (( moves > longer_num1 )); then
            longer_num1=$moves
            echo $longer_num1 > longer_num1.txt
            echo $(cat "$size".txt) >> longer_num1.txt
        fi
        size=2
    elif (( size == 2 )); then
        if (( moves > longer_num2 )); then
            longer_num2=$moves
            echo $longer_num2 > longer_num2.txt
            echo $(cat "$size".txt) >> longer_num2.txt
        fi
        size=3
    elif (( size == 3 )); then
        if (( moves > longer_num3 )); then
            longer_num3=$moves
            echo $longer_num3 > longer_num3.txt
            echo $(cat "$size".txt) >> longer_num3.txt
        fi
        if (( $moves > 3 )); then
            break
        fi
        size=5
    elif (( size == 5 )); then
        if (( moves > longer_num5 )); then
            longer_num5=$moves
            echo $longer_num5 > longer_num5.txt
            echo $(cat "$size".txt) >> longer_num5.txt
        fi
        if (( $moves > 12 )); then
            break
        fi
        size=7
    elif (( size == 7 )); then
        if (( moves > longer_num7 )); then
            longer_num7=$moves
            echo $longer_num7 > longer_num7.txt
            echo $(cat "$size".txt) >> longer_num7.txt
        fi
        size=10
    elif (( size == 10 )); then
        if (( moves > longer_num10 )); then
            longer_num10=$moves
            echo $longer_num10 > longer_num10.txt
            echo $(cat "$size".txt) >> longer_num10.txt
        fi
        size=20
    elif (( size == 20 )); then
        if (( moves > longer_num20 )); then
            longer_num20=$moves
            echo $longer_num20 > longer_num20.txt
            echo $(cat "$size".txt) >> longer_num20.txt
        fi
        size=50
    elif (( size == 50 )); then
        if (( moves > longer_num50 )); then
            longer_num50=$moves
            echo $longer_num1 > longer_num50.txt
            echo $(cat "$size".txt) >> longer_num50.txt
        fi
        size=100
    elif (( size == 100 )); then
        if (( moves > longer_num100 )); then
            longer_num100=$moves
            echo $longer_num100 > longer_num100.txt
            echo $(cat "$size".txt) >> longer_num100.txt
        fi
        if (( $moves > 700 )); then
            break
        fi
        size=500
    elif (( size == 500 )); then
        if (( moves > longer_num500 )); then
            longer_num500=$moves
            echo $longer_num500 > longer_num500.txt
            echo $(cat "$size".txt) >> longer_num500.txt
        fi
        if (( $moves >= 5500 )); then
            break 
        fi  
        size=1
    fi
done