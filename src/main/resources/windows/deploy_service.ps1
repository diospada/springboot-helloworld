param([String]$serviceName,[String]$jarName)
$serviceNameXml = "$serviceName.xml"
$serviceNameExe = "$serviceName.exe"

write-output "Installing windows service $serviceName"
#create xml file necessary to install microservice as windows service
powershell -Command "(gc deploy_service.xml) -replace '%SERVICE_NAME%', '$serviceName' -replace '%JAR_NAME%', '$jarName' | Out-File -encoding ASCII $serviceNameXml"
#rename exe that need to invoked to install microservice as windows service
Rename-Item -Path 'WinSW.NET4.exe' -NewName $serviceNameExe
