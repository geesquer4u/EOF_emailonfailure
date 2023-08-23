#get-content E:\*\*\*\DEV\log.txt -Tail 1000 | set-content C:\path\local.txt

#Daily at 12:00 AM & PM, we need to run: Clear-Content "C:\path\cache.txt" to make it empty

$local = 'C:\path\local.txt'
$body = 'C:\path\body.txt'
$errorlist = 'C:\path\errorlist.txt'

Clear-Content "$body"
Clear-Content "$errorlist"


Foreach($A in Get-Content $local)
{
    If($A -match "error|invalid|failed|disconnect|Stopped")
	{
    Write-Host "A"
    Add-Content $body "$A"
	}
}

$diff = Get-Content $body | Where-Object {$_ -notin (Get-Content C:\path\cache.txt)}

$diff | Out-File $errorlist

if ((Get-Content "$errorlist") -ne $Null)
{
	$Attachment = $errorlist
    $password = ConvertTo-SecureString 'passwrd' -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ('urmailu@mail.com', $password)
    Send-MailMessage -From urmailu@mail.com -to theirmailu@mail.com -Subject 'Application errors!' -Body 'View attachment for error details' -SmtpServer 'smtp.details' -port portnumeric -UseSsl -Credential $credential -Attachments $Attachment
}

if ((Get-Content "$errorlist") -ne $Null)
{
Foreach($B in Get-Content $errorlist)
{
    If($B -match "error|invalid|failed|disconnect|Stopped")
	{
    Write-Host "B"
    Add-Content C:\path\cache.txt "$B"
	}
}
}