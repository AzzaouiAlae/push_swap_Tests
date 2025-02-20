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
    if (( $(valgrind ./push_swap $nums 2>&1 | grep "no leaks" | wc -l) != 1)); then
        echo fail
        valgrind ./push_swap $nums
        break
    fi
    if (( $(valgrind ./push_swap $nums 2>&1 | grep " 0 errors" | wc -l) != 1)); then
        echo fail
        valgrind ./push_swap $nums
        break
    fi
    if (( testNum == 1 )); then
        if [[ -n $(./push_swap $nums 2>&1 | cat -e) ]]; then
            echo fail
            echo "push swap show "$( ./push_swap $nums 2>&1 | cat -e)
        else
            echo Pass
        fi
    else
        if [[ $(./push_swap $nums 2>&1 | cat -e) != "Error$" ]]; then
            echo fail
            echo "push swap show \""$(./push_swap $nums 2>&1 | cat -e)"\""
        else
            if [[ $(./push_swap $nums 2>/dev/null) == "" ]]; then
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
