Function ENROLAMIENTO_GET-Reporte{
Param ($token,$URL_sitio,$curso,$uriDesfase) #id es el código clave del curso para APIs (por ej. _23_1)
#ENROLAMIENTO_GET-Reporte $token $URL_sitio $curso
$pathCurso='D:\__Ricardo\EXT_DIR\BB_Enrolamientos\'
$pathReporte=$pathCurso+'APIRptEnrolamiento__'+$curso +'.txt'
if (($uriDesfase.length -gt 10) -and ($uriDesfase.IndexOf($curso) -gt 10)){
$uri=$URL_sitio+$uriDesfase
} else {
$uriDesfase=''
$uri=$URL_sitio+'/learn/api/public/v1/courses/courseId:'+$curso+'/users?fields=courseId,userId,availability.available,courseRoleId,lastAccessed&limit=100'
Set-Content -Path $pathReporte -Value "Curso: $curso"
}
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
write-output $Resultadofn.results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathReporte
if ($Resultadofn.paging.nextpage.length -gt 10){
    $uriDesfase=$Resultadofn.paging.nextpage
    ENROLAMIENTO_GET-Reporte $token $URL_sitio $curso $uriDesfase
}
Return 
}

Function ENROLAMIENTO_GET-ReportePantalla{
Param ($token,$URL_sitio,$curso,$uriDesfase) #id es el código clave del curso para APIs (por ej. _23_1)
#ENROLAMIENTO_GET-ReportePantalla $token $URL_sitio $curso
$pathCurso='D:\__Ricardo\EXT_DIR\BB_Enrolamientos\'
$pathReporte=$pathCurso+'APIRptEnrolamiento__'+$curso +'.txt'
if (($uriDesfase.length -gt 10) -and ($uriDesfase.IndexOf($curso) -gt 10)){
$uri=$URL_sitio+$uriDesfase
write-output $uri
} else {
$uriDesfase=''
$uri=$URL_sitio+'/learn/api/public/v1/courses/courseId:'+$curso+'/users?fields=courseId,userId,availability.available,courseRoleId,lastAccessed&limit=100'
}
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
write-output $Resultadofn.results | ConvertTo-Csv -NoTypeInformation 
write-output ($Resultadofn.paging| Out-String).length
if ( ($Resultadofn.paging| Out-String).length -gt 10){
    $uriDesfase=$Resultadofn.paging.nextpage
    ENROLAMIENTO_GET-Reporte $token $URL_sitio $curso $uriDesfase
}
Return 
}

Function ENROLAMIENTO_PATCH-Visibilidad{
Param ($token,$URL_sitio,$courseId,$userName,$Visibilidad,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#ENROLAMIENTO_PATCH-Visibilidad $token $URL_sitio courseId: userName: $Visibilidad
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/users/'+$userName
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$availability=@{
            "available"=$Visibilidad
            }
$body = @{
        "availability"=$availability
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
if($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body 
    return
    }
else {
    try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body 
    $salida=$courseId + ' - ' +$userName +' ok'
    }
    catch{
    $salida=$courseId + ' - ' +$userName +' falló'
    }
    Return $salida
    }
}


Function ENROLAMIENTO_DELETE{
Param ($token,$URL_sitio,$courseId,$userName,$debug) 
#ENROLAMIENTO_DELETE $token $URL_sitio $courseId $userName $debug
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/users/'+$userName
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers 
    return
    } else {
    try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers 
    $salida=$courseId + ' - ' +$userName +' eliminado'
    }
    catch{
    $salida=$courseId + ' - ' +$userName +' falló'
    }
    Return $salida
    }
}



Function ENROLAMIENTO_PATCH-Rol{
Param ($token,$URL_sitio,$courseId,$userName,$Rol,$Debug) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/users/'+$userName
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "courseRoleId"=$Rol
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
if ($Debug -eq 'Yes')
{Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
Return
} else
{
try{
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
$salida=$courseId + ' - ' +$userName +' ok'
}
catch{
$salida=$courseId + ' - ' +$userName +' falló'
}
Return $salida}
}

Function ENROLAMIENTO_PUT-Crear{
Param ($token,$URL_sitio,$courseId,$userId,$rol,$debug) 
#ENROLAMIENTO_PUT-Crear $token $URL_sitio courseId: userName: $rol
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/users/'+$userId
$availability=@{
    "available"= "Yes";
    }
$body = @{
          "dataSourceId"="_2_1";
          "availability"= $availability;
          "courseRoleId"= $rol;
        }
$body =$body  | ConvertTo-Json
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
Write-Output $courseId 
Write-Output $userId
if ($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $body
    return
    } else {
    try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $body
        $Resultadofn=$courseId + ' _ ' + $userId +' > ok'}
    catch{
        $Resultadofn='ENROLAMIENTO_PUT-Crear '+'$'+'token '+'$'+'URL_sitio '+$courseId+' '+$userId+' '+$rol+' #>falló'
        }
    Return $Resultadofn
    }
}

Function ENROLAMIENTO_GET-Curso{
Param ($token,$URL_sitio,$courseId,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#ENROLAMIENTO_GET-Curso $token $URL_sitio courseId: 
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/users'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if($debug -ne 'Yes'){
    $Resultadofn=(Invoke-RestMethod -Uri $uri -Method Get -Headers $headers) 
    $Salida=$Resultadofn.Results}
else {
    try{
        $Resultadofn=(Invoke-RestMethod -Uri $uri -Method Get -Headers $headers )
        $Salida=$Resultadofn.Results
        }
    catch{
        $Salida=$courseId + ' - falló'
        }
    }
    Return $Salida
}
