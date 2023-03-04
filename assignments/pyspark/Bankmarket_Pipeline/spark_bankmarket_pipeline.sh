#!/bin/bash

echo "*** Started Execution *****"

echo "executing bank_load.py"
spark-submit bank_load.py

if [ $? -eq 0 ]
then
    echo "executing bank_cleaning.py"
    spark-submit bank_cleaning.py
    if [ $? -eq 0 ]
    then 
        echo "executing  bank_transformation.py"
        spark-submit --jars "/home/bigdata/mysql-connector-j-8.0.32/mysql-connector-j-8.0.32.jar" bank_transformation.py
        if [ $? -eq 0 ]
        then
            echo  "All Jobs done"
        else
            echo "============== ERROR in bank_transformation.py  ==================="
        fi
    else
        echo "================ ERROR in bank_cleaning.py  ===================="
    fi 
else
    echo "================ ERROR in FILE bank_load.py =================="
fi
echo "Good Work :)"