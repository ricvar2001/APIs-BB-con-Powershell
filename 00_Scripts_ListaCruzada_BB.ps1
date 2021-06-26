Function LC_GET-Reporte{
Param ($token,$URL_sitio,$curso) #id es el código clave del curso para APIs (por ej. _23_1)
#LC_GET-Reporte $token $URL_sitio $courseId 
$pathLC='D:\__Ricardo\EXT_DIR\BB_LC\'
$pathReporte=$pathLC+'APIRptLC_'+$curso+'.txt'
$uri=$URL_sitio+'/learn/api/public/v1/courses/courseId:'+$curso+'/children?fields=id,parentId'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
try{
$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
Set-Content -Path $pathReporte -Value ''
write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathReporte
}
catch
{write-output "$curso Hijo"}
Return 
}

Function LC_Get-CursosHijos{
Param ($token,$URL_sitio,$courseId) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v1/courses/courseId:'+$courseId+'/children'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
Return $Resultadofn.courseId
}

Function LC_PUT-Crear{
Param ($token,$URL_sitio,$courseId,$childCourseId,$debug) 
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/children/'+$childCourseId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "ignoreEnrollmentErrors"="True"
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
if ($debug -eq 'Yes') 
     {
    Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $body
    }
else {
        $salida='Sin respuesta'
        try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $body # | Select-Object -Skip 1 
        $salida=$Resultadofn.childCourseId +' > Enlazado'}
        catch{
        $salida=$courseId + ' - ' + $childCourseId +' No'+$Resultadofn
        }
    }
Return $salida
}

Function LC_DELETE-DesligarNRC{
Param ($token,$URL_sitio,$courseId,$childCourseId,$debug) 
# LC_DELETE-DesligarNRC $token $URL_sitio courseId: courseId:
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/children/'+$childCourseId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "separationStyle"="completeSeparation"
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
if ($debug -eq 'Yes') 
     {
    Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers -Body $body
    salida=$Resultadofn.childCourseId +' > Desligado'
    }
else {
        $salida='Sin respuesta'
        try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers -Body $body # | Select-Object -Skip 1 
        $salida=$Resultadofn.childCourseId +' > Desligado'}
        catch{
        $salida=$courseId + ' - ' + $childCourseId +' No'+$Resultadofn
        }
    }
Return $salida
}