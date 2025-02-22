#!/bin/bash
clear

testNum=0
output=""
exit_status=0
while IFS= read -r nums;
do
    ((testNum++))
    echo -n $testNum "try sort "
    echo -e "\e[32m===> $nums <===\e[0m"
    valgrind ./push_swap $nums 2>&1 2> temp.txt
    if (( $(cat temp.txt | grep "no leaks" | wc -l) != 1)); then
        echo fail        
        valgrind ./push_swap $nums
        break
    fi
    if (( $(cat temp.txt | grep " 0 errors" | wc -l) != 1)); then
        echo fail
        valgrind ./push_swap $nums
        break
    fi
    ./push_swap $nums 2>&1 2> temp.txt
    if (( testNum == 1 )); then
        if (( $(cat temp.txt | wc -c) != 0 )); then            
            echo fail
            echo "push swap show "$(cat temp.txt)
        else
            echo Pass
        fi
    else
        if [[ $(cat -e temp.txt) != "Error$" ]]; then
            echo fail
            echo "push swap show \""$(cat -e temp.txt)"\""
        else
            ./push_swap $nums 2>/dev/null > temp.txt
            if (( $(cat temp.txt | wc -c) == 0 )); then
                ./push_swap $nums 2>/dev/null
                exit_status=$(echo $?)
                if (( $exit_status != 255 )); then
                    echo fail
                    echo "your exit status is $exit_status, it should be 255"
                else
                    echo Pass
                fi
            else
                echo fail
                echo "your push swap not print in stderr"
            fi
        fi
    fi
    echo "============================"
done < Errors.txt
