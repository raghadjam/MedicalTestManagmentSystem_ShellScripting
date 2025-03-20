displaymenu(){
echo "select your option"
echo "1. Add a new medical test record."
echo "2. Search for a test by patient ID,Retrieve all patient test."
echo "3. Search for a test by patient ID, Retrieve all up normal patient tests."
echo "4. Search for a test by patient ID Retrieve all patient tests in a given specific period"
echo "5. Search for a test by patient ID, Retrieve all patient tests based on test status "
echo "6. Searching for up normal tests."
echo "7. Average test value."
echo "8. Update an existing test result."
echo "9. Delete a test."
echo "10.Exit."
}


#case1
AddNewMedical() {
echo "Please enter the medical record you want to add in the following format:"
echo "ID: test name, date, result, unit, status"
echo "For example: 1300511: LDL, 2024-03, 110, mg/dL, pending"
echo "Make sure to include the correct spacing and punctuation."
read str
grep -w "$str" medicalRecord.txt > /dev/null
if [ $? -eq 0 ]
then
echo "The medical record you enter is already exsit."
else
id=$(echo "$str" | cut -d':' -f1) # extract id from str
echo "$id" | grep '^[0-9]\{7\}$' > /dev/null # match id if it is from 7 digits number. /dev:When you want to run a command but don’t want to see its output
if [ $? -eq 0 ] # if the line before this line is correct
then
test=$(echo "$str" | cut -d',' -f1 | cut -d':' -f2 | cut -d' ' -f2) # extract test from str
if grep -w "$test" medicalTest.txt > /dev/null # check if the test is exist. -w ensures that the entire word matches, not just a substring
# /dev:When you want to run a command but don’t want to see its output
then
date=$(echo "$str" | cut -d',' -f2) # extract date from str
month=$(echo "$date" | cut -d'-' -f2)
if [ "$month" -le 12 ]
then
echo "$date" | grep '^ [0-9]\{4\}-[0-9]\{2\}$' > /dev/null # match the date if it is like this format YYYY-MM
# /dev:When you want to run a command but don’t want to see its output
if [ $? -eq 0 ] # if the line before this line is correct
then
value=$(echo "$str" | cut -d',' -f3) # extract date from str
if echo "$value" | grep -E '^ [0-9]+(\.[0-9]+)?$' > /dev/null
then
unit=$(echo "$str" | cut -d',' -f4)
if [ "$unit" = " mg/dL" -o "$unit" = " mm Hg" -o "$unit" = " g/dL"  ]
then
status=$(echo "$str" | cut -d',' -f5)
if echo "$status" | grep -w '^ [a-zA-Z]\+$' > /dev/null 
then
echo  "$str" >> medicalRecord.txt # add the medical record to the file
echo "The file is:"
cat medicalRecord.txt # print the file
else
echo "Ivalid status"
fi
else
echo "Ivalid unit"
fi
else
echo "Ivalid value"
fi
else 
echo "Ivalid date format"
fi
else
echo "Ivalid month"
fi
else
echo "Test does not exist"
fi
else
echo "Invalid ID format"
fi
fi
}


#case2
searchPatientTests(){
echo "Please enter the patient ID you want to search:"
read patientID
grep -w "$patientID" medicalRecord.txt # check if the ID is exist.-w whole word only 
pID=$(echo $?) 
if [ "$pID" -ne 0 ] # if the line before this line is correct.
then 
echo "invalid ID"
fi
}


#case3
searchUpNormal(){
echo "Please enter the patient ID you want to search:"
read patID 
grep -w "$patID" medicalRecord.txt > patientsTest.txt # check if the ID is exist.
pat=$(echo $?) 
f=1
if [ "$pat" -ne 0 ] # if the line before this line is correct.
then 
echo "invalid ID"
f=0
fi
variable=$(wc -l patientsTest.txt | cut -d' ' -f1) # find the number of patients (number of lines)
i=1
flag=0
while [ "$i" -le "$variable" ]
do
tes=$(sed -n "$i p" patientsTest.txt | cut -d',' -f1 | cut -d':' -f2 | cut -d' ' -f2) # extract test from line i
range=$(sed -n "$i p" patientsTest.txt | cut -d',' -f3) # extract id from line i
# find the up normal tests:
if [ "$tes" = "Hgb" ]
then
result=$(echo "$range < 13.8 || $range > 17.2" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then
echo "Up normal patient test:"
sed -n "$i p" patientsTest.txt #sed prints in the terminal
flag=1 #to check if there is no up normal tests for this patient
fi
elif [ "$tes" = "BGT" ]
then
result=$(echo "$range < 70 || $range > 80" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then
echo "Up normal patient test:"
sed -n "$i p" patientsTest.txt #sed prints in the terminal
flag=1
fi
elif [ "$tes" = "LDL" ]
then
result=$(echo "$range > 100" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then 
flag=1
echo "Up normal patient test:" 
sed -n "$i p" patientsTest.txt #sed prints in the terminal
fi
elif [ "$tes" = "systole" ]
then
result=$(echo "$range > 120" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then
flag=1
echo "Up normal patient test:" 
sed -n "$i p" patientsTest.txt #sed prints in the terminal
fi
else
result=$(echo "$range > 80" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then 
flag=1
echo "Up normal patient test:" 
sed -n "$i p" patientsTest.txt #sed prints in the terminal
fi
fi
i=$((i + 1))
done
if [ "$f" -eq 1 -a  "$flag" -eq 0 ]
then
echo "no up normal test"
fi
}


#case4
searchperiod(){
echo "Please enter the patient ID you want to search:"
read patID 
grep -w "$patID" medicalRecord.txt > patientsPeriod.txt # check if the ID is exist.
pat=$(echo $?) 
f=1
if [ "$pat" -ne 0 ] # if the line before this line is correct.
then 
echo "invalid ID"
f=0
else
echo "please enter the first date in fixed format like YYYY-MM<<Ensure that the earlier date is entered first>>:"
read date1 
echo "$date1" | grep  '^[0-9]\{4\}-[0-9]\{2\}$' > /dev/null # match the date if it is like this format YYYY-MM
if [ $? -eq 0 ] # if the line before this line is correct
then
year1=$(echo "$date1" | cut -c1-4) # extract year from date 
month1=$(echo "$date1" | cut -c6-7) # extract month from date
if [ "$month1" -le 12 ] # check if the month is correct
then
echo "please enter the second date fixed format like YYYY-MM which Y&M is numbers:"
read date2
echo "$date2" | grep '^[0-9]\{4\}-[0-9]\{2\}$' > /dev/null # match the date if it is like this format YYYY-MM
if [ $? -eq 0 ] # if the line before this line is correct
then
year2=$(echo "$date2" | cut -c1-4) # extract year from date 
month2=$(echo "$date2" | cut -c6-7) # extract month from date 
if [ "$month2" -le 12 ] # check if the month is correct 
then
variable1=$(wc -l patientsPeriod.txt | cut -d' ' -f1) # find the number of lines
j=1
flag=0
while [ "$j" -le "$variable1" ]
do
year=$(sed -n "$j p" patientsPeriod.txt | cut -d',' -f2 | cut -d'-' -f1)
month=$(sed -n "$j p" patientsPeriod.txt | cut -d',' -f2 | cut -d'-' -f2)
if [ "$year" -gt "$year1" -a "$year" -lt "$year2" ]
then 
sed -n "$j p" patientsPeriod.txt
flag=1
fi
if [ "$year" -eq "$year1" -a "$year" -eq "$year2" ]
then
if [ "$month" -ge "$month1" -a "$month" -le "$month2" ]
then
sed -n "$j p" patientsPeriod.txt
flag=1
fi
fi
if [ "$year" -eq "$year1" -a "$year" -lt "$year2" ]
then
if [ "$month" -ge "$month1" ]
then
sed -n "$j p" patientsPeriod.txt
flag=1
fi
fi
if [ "$year" -gt "$year1" -a "$year" -eq "$year2" ]
then
if [ "$month" -le "$month2" ]
then
sed -n "$j p" patientsPeriod.txt
flag=1
fi
fi

j=$((j + 1))
done
if [ "$flag" -eq 0 ]
then
echo "no tests exist in the given period."
fi
else
echo "Invalid month"
fi
else 
echo "Invalid date format"
fi
else 
echo "Invalid month"
fi
else 
echo "Invalid date format"
fi
fi
}


#case5
searchstatus(){
echo "Please enter the patient ID you want to search:"
read patID 
grep -w "$patID" medicalRecord.txt > patientsStatus.txt # check if the ID is exist.
pat=$(echo $?) 
f=1
if [ "$pat" -ne 0 ] # if the line before this line is correct.
then 
echo "invalid ID"
f=0
else
echo "please enter the status:"
read status
status=$(echo "$status" | tr '[a-z]' '[A-Z]') 
variable2=$(wc -l patientsStatus.txt | cut -d' ' -f1) # number of lines
k=1 
flagg=0 # check if there is no test with this status
while [ "$k" -le "$variable2" ]
do
stat=$(sed -n "$k p" patientsStatus.txt | cut -d',' -f5 | tr '[a-z]' '[A-Z]')
if [ " $status" = "$stat" ]
then
sed -n "$k p" patientsStatus.txt
flagg=1 
fi
k=$((k + 1))
done
if [ "$flagg" -eq 0 ]
then
echo "no tests exist ."
fi
fi
}


#case6
searchTestName(){
echo "Please enter the test name you want to search:"
read TestName
grep "$TestName" medicalRecord.txt > testName.txt
testt=$(echo $?) # if the line before this line is correct
f=1
if [ "$testt" -ne 0 ]
then 
echo "invalid test name"
f=0 
fi
variable3=$(wc -l testName.txt | cut -d' ' -f1) # number of lines
l=1
fl=0
while [ "$l" -le "$variable3" ]
do
te=$(sed -n "$l p" testName.txt | cut -d',' -f1 | cut -d':' -f2 | cut -d' ' -f2) # extract test from line i
rang=$(sed -n "$l p" testName.txt | cut -d',' -f3) # extract id from line i  
# find the up normal tests:
if [ "$te" = "Hgb" ]
then
result=$(echo "$rang < 13.8 || $rang > 17.2" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then
echo "Up normal patient test:"
sed -n "$l p" testName.txt #sed prints in the terminal
fl=1 #to check if there is no up normal tests for this patient
fi
elif [ "$te" = "BGT" ] 
then
result=$(echo "$rang < 70 || $rang > 99" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then
echo "Up normal patient test:"
sed -n "$l p" testName.txt #sed prints in the terminal
fl=1 #to check if there is no up normal tests for this patient
fi
elif [ "$te" = "LDL" ]
then
result=$(echo "$rang > 100" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then 
echo "Up normal patient test:"
sed -n "$l p" testName.txt #sed prints in the terminal
fl=1 #to check if there is no up normal tests for this patient
fi
elif [ "$te" = "systole" ]
then
result=$(echo "$rang > 120" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then
echo "Up normal patient test:"
sed -n "$l p" testName.txt #sed prints in the terminal
fl=1 #to check if there is no up normal tests for this patient
fi
else
result=$(echo "$rang > 80" | bc -l) # bc -l to write floating number
if [ "$result" -eq 1 ]
then 
echo "Up normal patient test:"
sed -n "$l p" testName.txt #sed prints in the terminal
fl=1 #to check if there is no up normal tests for this patient
fi
fi
l=$((l + 1))
done
if [ "$f" -eq 1 -a  "$fl" -eq 0 ]
then
echo "no up normal test"
fi
}


#case7
AvargeTestValue(){
variable4=$(wc -l medicalTest.txt | cut -d' ' -f1) #number of lines
i=1
while [ "$i" -le "$variable4" ]
do
testname=$(sed -n "$i p" medicalTest.txt | cut -d';' -f1 |  cut -d':' -f2) #extract test name
range=$(sed -n "$i p" medicalTest.txt | cut -d';' -f2) #extract range
if [ "$i" -le 2 ]
then
num1=$(echo "$range" | cut -d' ' -f4 | cut -d',' -f1) #extract num1 from range
num2=$(echo "$range" | cut -d' ' -f6) #extract num2 from range
avg=$(echo "($num1 + $num2) / 2" | bc -l) # bc -l for floating numbers
echo "The avarge in "$testname" between "$num1" and "$num2" is:"
printf "%.2f\n" "$avg" # two digits after the point
else
num1=$(echo "$range" | cut -d' ' -f4)
echo "Only one value provide in"$testname" which is less the "$num1" "
fi 
i=$((i + 1))
done
}


#case8
Update(){
echo "please enter the ID:"
read patID
grep "$patID" medicalRecord.txt > patientsID.txt #check if the id is exist
pat=$(echo $?) 
if [ "$pat" -ne 0 ] # if the line before this line is correct
then 
echo "The ID doesn't exist"
else 
echo "please enter the test name you want to change the value of"
read testname
grep "$patID: $testname" medicalRecord.txt > patientstest.txt #check if the test name is exist
name=$(echo $?)
if [ "$name" -ne 0 ] # if the line before this line is correct
then
echo "The test fot the id patient you enter doesn't exist"
else 
echo "please enter the new value:" 
read value
variable4=$(wc -l <  patientstest.txt) #number of lines
i=1
while [ "$i" -le "$variable4" ]
do
line=$(sed -n "${i}p" patientstest.txt)
id=$(echo "$line" | cut -d':' -f1)
te=$(echo "$line" | cut -d',' -f1 | cut -d':' -f2 | cut -d' ' -f2)
if [ "$id: $te" = "$patID: $testname" ]
then 
range=$(echo "$line" | cut -d',' -f3) #extract range  
sed -i "/$patID: $testname/s/$range/ $value/" medicalRecord.txt # replace the old range with new range
fi
i=$((i + 1))
done 
cat medicalRecord.txt #print the file
fi
fi
}


#case9
DeleteTest(){
#outdated
current=$(date +%Y-%m)
year=$(echo "$current" | cut -c1-4) # extract year from date 
month=$(echo "$current" | cut -c6-7) # extract month from date
variable=$(wc -l medicalRecord.txt | cut -d' ' -f1) # number of lines
i=1
while [ "$i" -le "$variable" ]
do
test=$(sed -n "$i p" medicalRecord.txt | cut -d',' -f1 | cut -d':' -f2 | cut -d' ' -f2) # extract test from str
if grep -w "$test" medicalTest.txt > /dev/null # check if the test is exist. -w ensures that the entire word matches, not just a substring
# /dev:When you want to run a command but don’t want to see its output
then
year1=$(sed -n "$i p" medicalRecord.txt | cut -d',' -f2 | cut -d'-' -f1 | cut -d' ' -f2)
month1=$(sed -n "$i p" medicalRecord.txt | cut -d',' -f2 | cut -d'-' -f2 )
year1=$((year1+1))
if [ "$year1" -lt "$year" ]
then
sed -i "$i d" medicalRecord.txt
variable=$((variable-1))
continue 
fi
if [ "$year1" -eq "$year" ]
then
if [ "$month1" -lt "$month" ]
then 
sed -i "$i d" medicalRecord.txt 
variable=$((variable-1))
continue  
fi
fi
else
sed -i "$i d" medicalRecord.txt 
variable=$((variable-1))
continue  
fi
i=$((i + 1))
done
cat medicalRecord.txt
}



validAnswer(){
while true
do 
read answer
if echo "$answer" | grep -E '^[0-9]+$' > /dev/null
then
if [ "$answer" -ge 1 ] && [ "$answer" -le 10 ]
then
break
else
echo "Ivalid number,please enter a number between 1 and 10."
displaymenu
fi
else
echo "Invalid input, please enter a valid number between 1 and 10."
displaymenu
fi
done
}

while true
do
displaymenu
validAnswer
case "$answer"
in
1) AddNewMedical;;
2) searchPatientTests;;
3) searchUpNormal;;
4) searchperiod;;
5) searchstatus;;
6) searchTestName;;
7) AvargeTestValue;;
8) Update;;
9) DeleteTest;;
10) echo "Exiting..."; exit 0;;
*) echo "please enter a valid number";;
esac 
done
