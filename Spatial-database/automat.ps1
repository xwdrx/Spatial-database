#Install-Module -Name 7zip4Powershell

#____________________Changelog_________________________________
#AUTOMATED DATA PROCESSING SCRIPT
#Author: Wiktria Drożdż
#date: 12.12.2021
#______________________SCRYPT - paths to files__________________________________
$mPath="C:\Users\wikto\Desktop\lab9_auto"
${TIMESTAMP}= Get-Date -Format "MM.dd.yyyy" 
$pFile=-join ($mPath,"\PROCESSED")
if (-not(Test-Path -Path $pFile -PathType Leaf)){New-Item -ItemType "directory" -Path $pFile -Force -ErrorAction Stop}

$log=-join ($pFile,"\automat_${TIMESTAMP}.log")
if (-not(Test-Path -Path $log -PathType Leaf)){New-Item -ItemType File -Path $log -Force -ErrorAction Stop}
if((Get-Content $log).Length -ne 0){Clear-Content $log}


function getDate{
   
    Get-Date -Format "MM.dd.yyyy HH:mm:ss"
}

#1)________________DOWNLOADING FILES___________________________


$passowrdFile="agh"
${indexnumber}="402789"
${TIMESTAMP}= Get-Date -Format "MM.dd.yyyy" 

$LINK="https://home.agh.edu.pl/~wsarlej/Customers_Nov2021.zip"
$local="C:\Users\wikto\Desktop\lab9_auto\Customers_Nov2021.zip"

#_____________A DOWNLOADING FILES_________________
try{
$File=New-object System.Net.WebClient
$File.DownloadFile($LINK,$local)
$cDate=getDate
Write-Output ("DOWNLOADING FILES" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output ("DOWNLOADING FILES" + " - "+ $cDate +" - "+"FAILURE") >> $log}
#_____________B  UNZIP FILE_________________
try{

Expand-7Zip -ArchiveFileName $local -TargetPath $mPath -Password $passowrdFile
$cDate=getDate
Write-Output("UNZIP FILE" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("UNZIP FILE" + " - "+ $cDate +" - "+"FAILURE") >> $log}
#_______________C FILTERING FILE________________________

try{
$bad=-join ($mPath,"\Customers_Nov2021.bad_${TIMESTAMP}.txt")

if (-not(Test-Path -Path $bad -PathType Leaf)){New-Item -ItemType File -Path $bad -Force -ErrorAction Stop}  #nie ma pliku to go tworzy

$csv1= Get-Content -Path (-join ( $mPath,"\Customers_old.csv"))

Get-Content -Path (-join ( $mPath,"\Customers_Nov2021.csv")) | Where-Object{$_ -ne ""}|Where-Object{$csv1 -notcontains $_} | Out-File -FilePath (-join ( $mPath,"\Customers_filtered.csv"))  -Encoding utf8 #przefiltrowanie pliku

$csv2= Get-Content -Path (-join ( $mPath,"\Customers_filtered.csv"))

Get-Content -Path (-join ( $mPath,"\Customers_Nov2021.csv")) | Where-Object{$_ -ne ""}|Where-Object{$csv2 -notcontains $_} | Out-File -FilePath $bad #wywalenie blednych linii

Write-Output("FILTERING FILE" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("FILTERING FILE" + " - "+ $cDate +" - "+"FAILURE") >> $log}

#___________________D postgreSQL__________________

#Install-Module PostgreSQLCmdlets -Name PostgreSQLCmdlets -RequiredVersion 17.0.6634.0
#get-license

try{

Set-Location 'C:\Program Files\PostgreSQL\14\bin\'

#variables:
$User="postgres"
$Password="postgres"
$env:PGPASSWORD = $Password
$Database="lab9t"
$Server="PostgreSQL 14"
$Port="5432"
$table = "customers_${indexnumber}";  

psql -U $User -d $Database -w -c "DROP TABLE if exists $table"     

psql -U postgres -d $Database -w -c "Create table if not exists $table (first_name varchar(20), last_name varchar(20), email varchar(50), lat varchar(20), long varchar(20))"
Write-Output("CREATING TABLE" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("CREATING TABLE" + " - "+ $cDate +" - "+"FAILURE") >> $log}

#_____________________E LOADING DATA INTO A TABLE______________________________

psql -U $User -d $Database -w -c "\copy $table from 'C:\Users\wikto\Desktop\lab9_auto\Customers_filtered.csv' delimiter ','"
if($? -eq "True"){
Write-Output("LOADING DATA INTO A TABLE" + " - "+ $cDate +" - "+"SUCCESS") >> $log}
else{
Write-Output("LOADING DATA INTO A TABLE" + " - "+ $cDate +" - "+"FAILURE") >> $log}
#______________________F MOVING FILE TO THE PROCESSED DIRECTIORY___________

try{
if (-not(Test-Path -Path "$mPath\${TIMESTAMP}_Customers_filtered.csv" -PathType Leaf)){Rename-Item -Path "$mPath\Customers_filtered.csv" -NewName "${TIMESTAMP}_Customers_filtered.csv"}
 if (-not(Test-Path -Path "$mPath\PROCESSED\${TIMESTAMP}_Customers_filtered.csv" -PathType Leaf)){Move-Item "$mPath\${TIMESTAMP}_Customers_filtered.csv" -Destination "$mPath\PROCESSED"} 
 Write-Output("MOVING FILE TO THE PROCESSED DIRECTIORY" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("MOVING FILE TO THE PROCESSED DIRECTIORY" + " - "+ $cDate +" - "+"FAILURE") >> $log}
 #______________________G SENDING THE FIRST E-MAIL________________________
 try{
 
$tmp1=$csv1.Length
$tmp2=$csv2.Length
$tmp3=(Get-Content -Path (-join ( $mPath,"\Customers_Nov2021.bad_${TIMESTAMP}.txt"))).Length
$countTable=psql -U $User -d $Database -w -c "SELECT COUNT(*) FROM $table" | Select-Object -Index 2
$Username = "alertxv@gmail.com"
$EmailPassword = "Alert123*"




function Send-ToEmail([string]$email){
    $emailSmtpServer = "mail"
    $emailSmtpServerPort = "587"
    $message = new-object Net.Mail.MailMessage
    $message.From = "alertxv@gmail.com"
    $message.To.Add($email)
    $message.Subject = "CUSTOMERS LOAD - ${TIMESTAMP}"
    $message.Body = "
                     number of lines in the input file: $tmp1
                     number of lines after filtration: $tmp2
                     number of incorrect lines :$tmp3
                     number of data loaded into the $table : $countTable

     
    "
    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587")
    $smtp.EnableSSL = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $EmailPassword)
    $smtp.send($message);
    write-host "Message 1 sent"
 }
Send-ToEmail  -email "wiktoriad2340@gmail.com";
Write-Output("SENDING THE FIRST E-MAIL" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("SENDING THE FIRST E-MAIL" + " - "+ $cDate +" - "+"FAILURE") >> $log}
#______________________H QUERY USAGE____________________
try{
psql -U $User -d $Database -w -c "DROP TABLE if exists best_$table"
$query=-join ($mPath,"\query.txt")

psql -U postgres -d $Database -w -c "Create table if not exists best_$table (first_name varchar(20), last_name varchar(20), email varchar(50), lat varchar(20), long varchar(20))"
psql -U $User -d $Database -w -f "$query"


Write-Output("QUERY USAGE" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}

catch{
Write-Output("QUERY USAGE" + " - "+ $cDate +" - "+"FAILURE") >> $log}

#_________________I EXPORT TABLE TO A CSV FILE____________________________
try{

psql -U $User -d $Database -w -c "\copy best_$table to '$mPath\best_$table.csv' csv header " 
Write-Output("EXPORT TABLE TO A CSV FILE" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("EXPORT TABLE TO A CSV FILE" + " - "+ $cDate +" - "+"FAILURE") >> $log}

#_______________J FILE COMPRESSION_________________

try{
if (-not(Test-Path -Path "$mPath\best_$table.zip" -PathType Leaf)){Compress-Archive -Path "$mPath\best_$table.csv" -DestinationPath "$mPath\best_$table.zip" }
Write-Output("FILE COMPRESSION" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("FILE COMPRESSION" + " - "+ $cDate +" - "+"FAILURE") >> $log}

#__________________K SENDING A SECOND E-MAIL WITH ATTACHMENT ________________
try{
$tmp4=(Get-Content -Path (-join ( $mPath,"\best_$table.csv"))).Length
$lastWriteTime=Get-Item (-join ( $mPath,"\best_$table.csv")) | Select-Object  @{N=’Date of last modification’; E={$_.LastWriteTime}}
$path=-join($mPath,"\best_$table.zip")

function Send-ToEmail2([string]$email,[string]$attachmentpath){
    $emailSmtpServer = "mail"
    $emailSmtpServerPort = "587"
    $message = new-object Net.Mail.MailMessage
    $message.From = "alertxv@gmail.com"
    $message.To.Add($email)
    $message.Subject = "CUSTOMERS LOAD - ${TIMESTAMP}"
    $message.Body = "
                     number of lines in the input file: $tmp4
                     $lastWriteTime
     
    "
    $attachment = New-Object Net.Mail.Attachment($attachmentpath)
    $message.Attachments.Add($attachment)

    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587")
    $smtp.EnableSSL = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $EmailPassword)
    $smtp.send($message);
    write-host "Message 2 sent"
    $attachment.Dispose()
 }
Send-ToEmail2  -email "wiktoriad2340@gmail.com" -attachmentpath $path;
Write-Output("SENDING A SECOND E-MAIL WITH ATTACHMENT" + " - "+ $cDate +" - "+"SUCCESS") >> $log
}catch{Write-Output("SENDING A SECOND E-MAIL WITH ATTACHMENT" + " - "+ $cDate +" - "+"FAILURE") >> $log}
