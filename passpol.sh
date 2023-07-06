#!/bin/bash

Help () {
	echo "Usage: ./passpol.sh <<CME --pass-pol>>"$'\n'
	echo "-Spits out the CTIME string for \"Password Policy\""
  	echo "!***OUTPUT THE RESULTS OF CME --PASS-POL TO A FILE AND USE THAT FILE WITH THIS SCRIPT***!"
}

if [[ $1 == '' ]]; then
	echo "Please supply a file containing the password policy from CME or use -h for help"
	exit
 elif [[ $1 == '-h' ]]; then
	Help
	exit
fi

read -rp "Is MFA enabled? (yes/no): " mfa_status

# Convert the input to lowercase for case-insensitive comparison
mfa_status=$(echo "$mfa_status" | tr '[:upper:]' '[:lower:]')

# Check the user's input and set the MFAenabled variable
if [[ "$mfa_status" =~ ^(yes|y)$ ]]; then
  MFAenabled=1
elif [[ "$mfa_status" =~ ^(no|n)$ ]]; then
  MFAenabled=0
else
  echo "Invalid input. Assuming MFA is disabled."
  MFAenabled=0
fi

#strip all formatting out of the input
sed 's/\x1b\[[0-9;]*m//g' $1 > 764228fb7d6bdb58feb0887af12d2890.txt

#{"EnforcePasswordHistory":[{"Yes(1)/No(0)":0}],
enforcehistory=$(grep -oP "(?<=Password history length: )\d+" 764228fb7d6bdb58feb0887af12d2890.txt | tr -d '[:space:]')
if [[ $enforcehistory != 0 ]]; then
	echo "Password history is enforced (1)"
else
	echo "Password history is not enforced (0)"
fi

#"MaxPasswordAge":[{"Age(minutes)":x}],
maxpassage=$(grep -i "Maximum password age" 764228fb7d6bdb58feb0887af12d2890.txt | cut -d ':' -f2)
pass_days=$(echo $maxpassage | cut -d ' ' -f1)
days2mins=$((pass_days * 1440))
pass_hours=$(echo $maxpassage | cut -d ' ' -f3)
hours2mins=$((pass_hours * 60))
pass_mins=$(echo $maxpassage | cut -d ' ' -f5)
passagemins=$((days2mins + hours2mins + pass_mins))

echo $passagemins

#"PasswordHistoryLength":[{"Number":0}],
echo "PasswordHistoryLength is $enforcehistory"

#"MinPasswordLength":[{"Length":0}],
minpasslength=$(grep -i "Minimum password length" 764228fb7d6bdb58feb0887af12d2890.txt | cut -d ':' -f2 | tr -d ' ')
echo "The minpasslength is $minpasslength"

#"PasswordComplexityRequirements":[{"Number":0}],
passcomplex=$(grep -i "Domain Password Complex: " 764228fb7d6bdb58feb0887af12d2890.txt | cut -d ':' -f2 | tr -d ' ')
echo "Password complexity is set to $passcomplex"

#"PasswordsReversibleEncryption":[{"Yes(1)/No(0)":0}],
plaintext=$(grep -oP "(?<=Domain Password Store Cleartext: )\d+" 764228fb7d6bdb58feb0887af12d2890.txt | tr -d '[:space:]')
echo $plaintext
if [[ $plaintext == 0 ]]; then
	echo "Reversible Encryption is disabled (0)"
else
	echo "Reversible Encryption is enabled (1)"
	plaintext="1"
fi

#"AccountLockoutThreshold":
lockoutthreshold=$(grep -i "Account Lockout Threshold: " 764228fb7d6bdb58feb0887af12d2890.txt | cut -d ':' -f2)
echo "Account lockout threshold is $lockoutthreshold"
if [[ $lockoutthreshold == " None" ]]; then
	lockoutthreshold="0"
fi

#"AccountLockoutDuration"
lockoutduration=$(grep -i "Locked Account Duration: " 764228fb7d6bdb58feb0887af12d2890.txt | cut -d ':' -f2 | cut -d ' ' -f2)
echo "Accounts are locked out for $lockoutduration"

#"ResetAccountLockoutAfter"
resetlockout=$(grep -i "Reset Account Lockout Counter: " 764228fb7d6bdb58feb0887af12d2890.txt | cut -d ':' -f2 | cut -d ' ' -f2)
echo "Accounts are reset after $resetlockout"

echo "MFA is $MFAenabled"

ctime="
{\"EnforcePasswordHistory\":[{\"Yes(1)/No(0)\":$enforcehistory}],
\"MaxPasswordAge\":[{\"Age(minutes)\":$passagemins}],
\"PasswordHistoryLength\":[{\"Number\":$enforcehistory}],
\"MinPasswordLength\":[{\"Length\":$minpasslength}],
\"PasswordComplexityRequirements\":[{\"Number\":$passcomplex}],
\"PasswordsReversibleEncryption\":[{\"Yes(1)/No(0)\":$plaintext}],
\"AccountLockoutThreshold\":[{\"Number\":$lockoutthreshold}],
\"AccountLockoutDuration\":[{\"Length\":$lockoutduration}],
\"ResetAccountLockoutAfter\":[{\"Length\":$resetlockout}],
\"MFAEnabled\":[{\"Yes(1)/No(0)\":$MFAenabled}]}
"

echo "$ctime"

#removing temp file
rm 764228fb7d6bdb58feb0887af12d2890.txt
