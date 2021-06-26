Function CURSO_GET{
Param ($token,$URL_sitio,$courseId,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_GET $token $URL_sitio $courseId $debug
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'

$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if ($debug -eq 'Yes')
{Invoke-RestMethod -Uri $uri -Method get -Headers $headers }else
{
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers 
    write-output $Resultadofn
    write-output $Resultadofn.availability
    }
catch{
    write-output $courseId + ' > falló '+$uri    
    }
}
Return 
}


Function CURSO_GET-Reporte{
Param ($token,$URL_sitio,$desvio,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_GET-Reporte $token $URL_sitio $desvio $debug
$pathCurso='D:\__Ricardo\EXT_DIR\BB_Cursos\'
$pathReporte=$pathCurso+'APIRptCurso'+$desvio+'.txt'
$uri=$URL_sitio+'/learn/api/public/v3/courses/?fields=id,name,externalId,closedComplete,termId,availability.available,parentId&offset='+$desvio+'&limit=100'

$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

Set-Content -Path $pathReporte -Value ''
$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathReporte
Return 
}

Function CURSO_PATCH-Descripcion{
Param ($token,$URL_sitio,$courseId,$description) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'


$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "description"=$description
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$courseId +' > Descripción actualizada'
    }
catch{
    $salida=$courseId + ' > falló'    
    }
Return $salida
}

Function CURSO_PATCH-NombrePeriodo{
Param ($token,$URL_sitio,$courseId,$TituloCurso,$termId) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "name"=$TituloCurso
        "termId"=$termId
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$courseId +' > Nombre y periodo actualizados'
    }
catch{
    $salida=$courseId + ' > falló'    
    }
Return $salida
}

Function CURSO_PATCH-Periodo{  #202010-46-SPSU-834-000099723-001
Param ($token,$URL_sitio,$courseId,$termId) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_PATCH-Periodo $token $URL_sitio courseId: externalId:
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$tipoDuracion='Term';
$duration=@{
      "type"=$tipoDuracion;
        }
$availability=@{
      "available"='Term';  
      "duration"=$duration;
      }
$body = @{
        "availability"=$availability;
        "termId"=$termId
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$courseId +' > Periodo actualizados'
    }
catch{
    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    $salida=$courseId + ' > falló'    
    }
Return $salida
}

Function CURSO_PATCH-Completado{
Param ($token,$URL_sitio,$courseId,$completoTF,$debug) #completoTF (True o False)
#CURSO_PATCH-Completado $token $URL_sitio courseId: $completoTF
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "closedComplete"=$completoTF
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
if($completoTF -eq 'False')
   {$estado='Abierto'}else {$estado='Cerrado'}
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$Resultadofn.courseId +' > ' +$estado
    }
catch{
    $salida='courseId' + ' > falló'    
    }
if($debug -eq 'Yes'){
    Write-Output $Resultadofn
    }
Return $salida 
}

Function CURSO_PATCH-DuracionPeriodo{  #202010-46-SPSU-834-000099723-001
Param ($token,$URL_sitio,$courseId,$termId) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_PATCH-DuracionPeriodo $token $URL_sitio courseId: externalId:
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$tipoDuracion='Term';
$duration=@{
      "type"=$tipoDuracion;
        }
$availability=@{
      "available"='Term';  
      "duration"=$duration;
      }
$body = @{
        "availability"=$availability;
        "termId"=$termId;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$courseId +' > Periodo actualizados'
    }
catch{
    $salida=$courseId + ' > falló'    
    }
Return $salida
}


Function CURSO_PATCH-Fechas{
Param ($token,$URL_sitio,$courseId,$f_inicio,$f_fin,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_PATCH-Fechas $token $URL_sitio courseId: f_inicio f_fin $debug
CURSO_PATCH-Completado $token $URL_sitio $courseId False
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$tipoDuracion='DateRange'#'Continuous'
$duration=@{
      "type"=$tipoDuracion;
      "start"= $f_inicio;
      "end"= $f_fin;
        }
$availability=@{
      "available"='Yes';  
      "duration"=$duration;
      }
$body = @{
        "availability"=$availability;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
if ($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    return
    }
    else {
        try{
            $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
            $salida=$Resultadofn.courseId +' > Duración actualizada'
            }
        catch{
            $salida='courseId' + ' > falló'    
            }
        Return $salida
    }
}

Function CURSO_PATCH-Fechas_Descripcion{
Param ($token,$URL_sitio,$courseId,$f_inicio,$f_fin,$Descripcion) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$tipoDuracion='DateRange'#'Continuous'
$duration=@{
      "type"=$tipoDuracion;
      "start"= $f_inicio;
      "end"= $f_fin;
        }
$availability=@{
      "duration"=$duration;
      }
$body = @{
        "availability"=$availability;
        "description"=$description;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
#Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
#return
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$Resultadofn.courseId +' > Duración actualizada'
    }
catch{
    if ($Resultadofn.status -eq 400){
        $salida=$courseId + ' > falló pues está cerrado y completo'}
        else
        {
        $salida=$courseId + ' > falló'
        }
    }
Return $salida
}

Function CURSO_PATCH-DuracionContinua{
Param ($token,$URL_sitio,$courseId) 
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$duration=@{
      "type"="Continuous";
        }
$availability=@{
      "duration"=$duration;
      }
$body = @{
        "availability"=$availability;
        }
$body =$body  | ConvertTo-Json
#write-output $body
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
#Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
#return
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$Resultadofn.courseId +' > Duración actualizada'
    }
catch{
    if ($Resultadofn.status -eq 400){
        $salida=$courseId + ' > falló pues está cerrado y completo'}
        else
        {
        $salida=$courseId + ' > falló'
        }
    }
Return $salida
}

Function CURSO_PATCH-Nombre{
Param ($token,$URL_sitio,$courseId,$name) 
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "name"=$name
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
$salida=$Resultadofn.courseId +' > Nombre actualizad'
Return $salida
}

Function CURSO_PATCH-Disponible{
Param ($token,$URL_sitio,$courseId,$availableYN,$debug) 
#CURSO_PATCH-Disponible $token $URL_sitio courseId: YesNo
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$availability=@{
            "available"=$availableYN
            }
$body = @{
        "availability"=$availability
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
        if($debug -eq 'Yes'){
        Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
        return} else {
            try{
                $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
                $salida=$Resultadofn.courseId +' > Curso actualizado'
                }
            catch{
                if ($Resultadofn.status -eq 400){
                    $salida=$courseId + ' > falló pues está cerrado y completo'}
                    else
                    {
                    $salida=$courseId + ' > falló la inhabilitación'
                    }
                }
            Return $salida
        }
}

Function CURSO_GET-Todos{
Param ($token,$URL_sitio)
$uri=$URL_sitio+'/learn/api/public/v3/courses?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
$Resultadofn=$Resultadofn.Results| ConvertTo-Csv -NoTypeInformation #| Select-Object -Skip 1 
Return $Resultadofn
}

Function CURSO_GET-IdCurso{
Param ($token,$URL_sitio,$pk1) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$pk1+'#?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
#Return $Resultadofn.courseId
Return $Resultadofn
}

Function CURSO_DELETE{
Param ($token,$URL_sitio,$courseId,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_DELETE $token $URL_sitio $courseId $debug

$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

if($debug -eq 'Yes'){
        #Invoke-RestMethod -Uri $uri -Method Deletexxxxx -Headers $headers 
        Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers 
        return} else {
            try{
                #$Resultadofn=Invoke-RestMethod -Uri $uri -Method Deletexxxxx -Headers $headers 
                $Resultadofn=Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers 
                $salida=$Resultadofn.courseId +' > Curso eliminado'
                }
            catch{
                if ($Resultadofn.status -eq 400){
                    $salida=$courseId + ' > falló pues está cerrado y completo'}
                    else
                    {
                    $salida=$courseId + ' > falló la eliminación'
                    }
                }
            Return $salida
        }
}

Function CURSO_GET-Estado{
Param ($token,$URL_sitio,$courseId,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v3/courses/'+$courseId #'?fields=courseId,id'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
        $salida=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
        Return $salida
}
