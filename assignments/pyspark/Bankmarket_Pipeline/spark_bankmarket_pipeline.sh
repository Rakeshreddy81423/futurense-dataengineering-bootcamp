#!/bin/bash

echo "*** Started Execution *****" >> '/home/bigdata/pipeline_log/log.txt'

echo "============== executing bank-marketing-data-loading.py ===================="  >> '/home/bigdata/pipeline_log/log.txt'
spark-submit bank-marketing-data-loading.py

if [ $? -eq 0 ]
then
    echo "============== executing bank-marketing-validation.py ================" >> '/home/bigdata/pipeline_log/log.txt'
    spark-submit bank-marketing-validation.py
    if [ $? -eq 0 ]
    then 
        echo "================== executing  bank_marketing-transformation.py =====================" >> '/home/bigdata/pipeline_log/log.txt'
        spark-submit \
        --packages org.apache.spark:spark-avro_2.12:3.3.2 bank-marketing-transformation.py        
        if [ $? -eq 0 ]
        then
            echo "================== executing  bank_marketing-export.py =====================" >> '/home/bigdata/pipeline_log/log.txt'

            echo "==== starting MySQL====" >> '/home/bigdata/pipeline_log/log.txt'

            spark-submit \
            --packages org.apache.spark:spark-avro_2.12:3.3.2\
            --jars "/home/bigdata/mysql-connector-j-8.0.32/mysql-connector-j-8.0.32.jar" bank-marketing-export.py
            if [ $? -eq 0 ]
            then
                echo  "All Jobs done" >> '/home/bigdata/pipeline_log/log.txt'
            else
                echo "============== ERROR in bank-marketing-export.py  ===================" >> '/home/bigdata/pipeline_log/log.txt'
            fi
        else
            echo "============== ERROR in bank-marketing-transformation.py  ===================" >> '/home/bigdata/pipeline_log/log.txt'
        fi
    else
        echo "================ ERROR in bank-marketing-validation.py  ====================" >> '/home/bigdata/pipeline_log/log.txt'
    fi 
else
    echo "================ ERROR in FILE bank-marketing-data-loading.py ==================" >> '/home/bigdata/pipeline_log/log.txt'
fi
echo "================= Good Work :) =====================" >> '/home/bigdata/pipeline_log/log.txt'