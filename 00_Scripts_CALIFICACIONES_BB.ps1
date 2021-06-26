Function ESQUEMA_GET-Reporte{
Param ($token,$URL_sitio,$curso) #$curso es por ejemplo, 202020-AMOD-401-NRC_1545
#ESQUEMA_GET-Reporte $token $URL_sitio $curso
$pathCurso='D:\__Ricardo\EXT_DIR\BB_Esquemas\'
$pathReporte=$pathCurso+'APIRptESquema__'+$curso +'.txt'
$uri=$URL_sitio+'/learn/api/public/v1/courses/courseId:'+$curso+'/gradebook/schemas'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

Set-Content -Path $pathReporte -Value ''
$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathReporte
Return 
}

Function COLUMNAS_GET-Reporte{
Param ($token,$URL_sitio,$curso) #$curso es por ejemplo, 202020-AMOD-401-NRC_1545
#COLUMNAS_GET-Reporte $token $URL_sitio $curso 
$pathCurso='D:\__Ricardo\EXT_DIR\BB_Columnas\'
$pathReporte=$pathCurso+'APIRptESquema__'+$curso +'.txt'
$uri=$URL_sitio+'/learn/api/public/v2/courses/courseId:'+$curso+'/gradebook/columns'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

Set-Content -Path $pathReporte -Value "Curso: $curso"
$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
$Filtro='Type=C'
write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation |select-string $Filtro | Add-Content -Path $pathReporte
$Filtro='Type=W'
write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation |select-string $Filtro | Add-Content -Path $pathReporte
Return 
}

#POST /learn/api/public/v2/courses/{courseId}/gradebook/columns

Function CALIFICACIONES-GET-Columnas_PorCurso{
Param ($token,$URL_sitio,$courseId) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns'
write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers # | Select-Object -Skip 1 
Return $Resultadofn.Results#| ConvertTo-Csv -NoTypeInformation 
}

Function CALIFICACIONES-GET-PorCurso_Columna_Usuario{
Param ($token,$URL_sitio,$courseId,$userId,$columnaId,$periodo,$matcur,$id_alumno) #id es el código clave del curso para APIs (por ej. _23_1)
#$uri=$URL_sitio+'/learn/api/public/v2/courses/courseId:'+$courseId+'/gradebook/columns?fields=courseId,id,name,grading.scoringModel'
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnaId+'/users/'+$userid
write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
$salida=@{
    "periodo"=$periodo;
    "matcur"=$matcur;
    "id_alumno"=$id_alumno;
    "calificacion"=$Resultadofn}
Return $Resultadofn
}


Function CALIFICACIONES-GET-Usuarios_PorCurso_Columna{
Param ($token,$URL_sitio,$courseId,$idColumna) #id es el código clave del curso para APIs (por ej. _23_1)
#CALIFICACIONES-GET-Usuarios_PorCurso_Columna $token $URL_sitio $courseId $idColumna
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$idColumna+'/users?fields=userId,columnId,status,displayGrade.scaleType,displayGrade.score'
$archivoNotas=$courseId.split(':')[1]
$pathNotas='D:\__Ricardo\EXT_DIR\BB_Notas\'+$archivoNotas+'.txt'
write-output "$courseId $idColumna"| Add-Content -Path $pathNotas 
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
try {$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers}
catch {$a=1}
if ($Resultadofn.Results -eq $null)
    {Return "$courseId Sin notas"
    }
    else {
    write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathNotas
    Return "$courseId Procesado"
    #Return $Resultadofn.Results
    }
}

Function CALIFICACIONES-GET-Usuarios_PorCurso_ColumnaJson{
Param ($token,$URL_sitio,$courseId) #id es el código clave del curso para APIs (por ej. _23_1)
#CALIFICACIONES-GET-Usuarios_PorCurso_ColumnaJson $token $URL_sitio $courseId 
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/finalGrade/users?fields=userId,columnId,status,displayGrade.scaleType,displayGrade.text,displayGrade.score'
#$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/finalGrade/users'
$archivoNotas=$courseId.split(':')[1]
$pathNotas='D:\__Ricardo\EXT_DIR\BB_Notas\'+$archivoNotas+'.txt'
write-output "$courseId $idColumna"| Add-Content -Path $pathNotas 
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
try {$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers}
catch {$a=1}
if ($Resultadofn.Results -eq $null)
    {Return "$courseId Sin notas"
    }
    else {
    write-output $Resultadofn.Results  | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathNotas
    #write-output $Resultadofn.Results| Add-Content -Path $pathNotas
    Return "$courseId Procesado"
    #Return $Resultadofn.Results
    }
}

Function CALIFICACIONES-GET-PorCursoAlumno_ColumnaJson{
Param ($token,$URL_sitio,$courseId,$userName) #id es el código clave del curso para APIs (por ej. _23_1)
#CALIFICACIONES-GET-PorCursoAlumno_ColumnaJson $token $URL_sitio $courseId $userName
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/finalGrade/users/'+$userName+'?fields=userId,columnId,status,displayGrade.scaleType,displayGrade.text,displayGrade.score'
$archivoNotas=('ID_'+$courseId.split(':')[1]+'_'+$userName.split(':')[1])
$pathNotas='D:\__Ricardo\EXT_DIR\BB_Notas\'+$archivoNotas+'.txt'
write-output "$courseId $userName"| Add-Content -Path $pathNotas 
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

try {$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers}
catch {$a=1}
if ($Resultadofn -eq $null)
    {Return "$courseId _ $userName Sin notas"
    }
    else {
    write-output $Resultadofn | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathNotas
    Return "$courseId _ $userName Procesado"
    }
}


#Function CALIFICACIONES-GET-Usuarios_PorCurso_ColumnaJson{

#GET /learn/api/public/v2/courses/{courseId}/gradebook/columns/{columnId}/users/{userId}

Function CALIFICACIONES-GET-Columnas_PorCurso_UnaColumna{
Param ($token,$URL_sitio,$courseId,$columnId) #id es el código clave del curso para APIs (por ej. _23_1)
#CALIFICACIONES-GET-Columnas_PorCurso_UnaColumna $token $URL_sitio courseId $columnId
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers  # | Select-Object -Skip 1 
Return $Resultadofn
}

Function CALIFICACIONES-PATCH-Columna_Intentos{
Param($token,$URL_sitio,$courseId,$columnId,$attemptsAllowed)
#CALIFICACIONES-PATCH-Columna_Intentos $token $URL_sitio courseId: $columnId $attemptsAllowed
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$grading = @{
    "attemptsAllowed" = $attemptsAllowed;
    "scoringModel"= "Highest"
            }
$body = @{
         "grading"=$grading
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 

try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId $columnId > Modificado"
    }
catch{
    $salida="$courseId $columnId > Falló"
    }
Return $Resultadofn
}

Function CALIFICACIONES-PATCH-Columna_Intentos_Habilitar{
Param($token,$URL_sitio,$courseId,$columnId,$attemptsAllowed,$HabilitarYesNo,$nombre)
#CALIFICACIONES-PATCH-Columna_Intentos_Habilitar $token $URL_sitio courseId: $columnId $attemptsAllowed
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
$score = @{
    "possible"="20";
  }
$availability = @{
    "available"=$HabilitarYesNo;
  }
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$grading = @{
    "attemptsAllowed" = $attemptsAllowed;
    "scoringModel"= "Highest"
            }
$body = @{
         "grading"=$grading;
         "score"=$score;
         "availability"=$availability;
         "name"=$nombre
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 

try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId $columnId > Modificado"
    }
catch{
    $salida="$courseId $columnId > Falló"
    }
write-output $Resultadofn
write-output "Fin"
Return $Resultadofn
}

Function CALIFICACIONES-PATCH-Columna_Habilitar{
Param($token,$URL_sitio,$courseId,$columnId,$HabilitarYesNo)
#CALIFICACIONES-PATCH-Columna_Habilitar $token $URL_sitio courseId: $columnId $HabilitarYesNo
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
$availability = @{
    "available"=$HabilitarYesNo;
  }
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
         "availability"=$availability;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
#$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 

try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId $columnId > Modificado"
    }
catch{
    $salida="$courseId $columnId > Falló"
    }

write-output "Fin"
Return $Resultadofn
}

Function CALIFICACIONES-PATCH-Columna_Nombre{
Param($token,$URL_sitio,$courseId,$columnId,$nombre)
#CALIFICACIONES-PATCH-Columna_Nombre $token $URL_sitio courseId: $columnId $nombre
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body = @{
        "name"=$nombre
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId $columnId > Modificado"
    }
catch{
    $salida="$courseId $columnId > Falló"
    }
Return $salida
}

Function CALIFICACIONES-PATCH-Columna_MaxPuntaje{
Param($token,$URL_sitio,$courseId,$columnId,$MaxPuntaje)
#CALIFICACIONES-PATCH-Columna_MaxPuntaje $token $URL_sitio courseId: $columnId $MaxPuntaje
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$score= @{
    "possible"=$MaxPuntaje
         }
$body = @{
        "score"=$score
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId $columnId > Modificado"
    }
catch{
    $salida="$courseId $columnId > Falló"
    }
Return $salida
}

#Crear promedio con fórmula
#POST /learn/api/public/v2/courses/{courseId}/gradebook/columns



Function CALIFICACIONES-PATCH-Schema{
Param($token,$URL_sitio,$courseId,$schemaId)
#Actualiza un Esquema de Calificación
#CALIFICACIONES-PATCH-Schema $token $URL_sitio courseId: $schemaId
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/gradebook/schemas/'+$schemaId

$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$body=@{
  "symbols"=
   @( 
@{"text"="20.0";"absoluteValue"=99.870;"lowerBound"=99.750;"upperBound"=100.000},
@{"text"="19.9";"absoluteValue"=99.495;"lowerBound"=99.250;"upperBound"=99.750},
@{"text"="19.8";"absoluteValue"=98.995;"lowerBound"=98.750;"upperBound"=99.250},
@{"text"="19.7";"absoluteValue"=98.495;"lowerBound"=98.250;"upperBound"=98.750},
@{"text"="19.6";"absoluteValue"=97.995;"lowerBound"=97.750;"upperBound"=98.250},
@{"text"="19.5";"absoluteValue"=97.495;"lowerBound"=97.250;"upperBound"=97.750},
@{"text"="19.4";"absoluteValue"=96.995;"lowerBound"=96.750;"upperBound"=97.250},
@{"text"="19.3";"absoluteValue"=96.495;"lowerBound"=96.250;"upperBound"=96.750},
@{"text"="19.2";"absoluteValue"=95.995;"lowerBound"=95.750;"upperBound"=96.250},
@{"text"="19.1";"absoluteValue"=95.495;"lowerBound"=95.250;"upperBound"=95.750},
@{"text"="19.0";"absoluteValue"=94.995;"lowerBound"=94.750;"upperBound"=95.250},
@{"text"="18.9";"absoluteValue"=94.495;"lowerBound"=94.250;"upperBound"=94.750},
@{"text"="18.8";"absoluteValue"=93.995;"lowerBound"=93.750;"upperBound"=94.250},
@{"text"="18.7";"absoluteValue"=93.495;"lowerBound"=93.250;"upperBound"=93.750},
@{"text"="18.6";"absoluteValue"=92.995;"lowerBound"=92.750;"upperBound"=93.250},
@{"text"="18.5";"absoluteValue"=92.495;"lowerBound"=92.250;"upperBound"=92.750},
@{"text"="18.4";"absoluteValue"=91.995;"lowerBound"=91.750;"upperBound"=92.250},
@{"text"="18.3";"absoluteValue"=91.495;"lowerBound"=91.250;"upperBound"=91.750},
@{"text"="18.2";"absoluteValue"=90.995;"lowerBound"=90.750;"upperBound"=91.250},
@{"text"="18.1";"absoluteValue"=90.495;"lowerBound"=90.250;"upperBound"=90.750},
@{"text"="18.0";"absoluteValue"=89.995;"lowerBound"=89.750;"upperBound"=90.250},
@{"text"="17.9";"absoluteValue"=89.495;"lowerBound"=89.250;"upperBound"=89.750},
@{"text"="17.8";"absoluteValue"=88.995;"lowerBound"=88.750;"upperBound"=89.250},
@{"text"="17.7";"absoluteValue"=88.495;"lowerBound"=88.250;"upperBound"=88.750},
@{"text"="17.6";"absoluteValue"=87.995;"lowerBound"=87.750;"upperBound"=88.250},
@{"text"="17.5";"absoluteValue"=87.495;"lowerBound"=87.250;"upperBound"=87.750},
@{"text"="17.4";"absoluteValue"=86.995;"lowerBound"=86.750;"upperBound"=87.250},
@{"text"="17.3";"absoluteValue"=86.495;"lowerBound"=86.250;"upperBound"=86.750},
@{"text"="17.2";"absoluteValue"=85.995;"lowerBound"=85.750;"upperBound"=86.250},
@{"text"="17.1";"absoluteValue"=85.495;"lowerBound"=85.250;"upperBound"=85.750},
@{"text"="17.0";"absoluteValue"=84.995;"lowerBound"=84.750;"upperBound"=85.250},
@{"text"="16.9";"absoluteValue"=84.495;"lowerBound"=84.250;"upperBound"=84.750},
@{"text"="16.8";"absoluteValue"=83.995;"lowerBound"=83.750;"upperBound"=84.250},
@{"text"="16.7";"absoluteValue"=83.495;"lowerBound"=83.250;"upperBound"=83.750},
@{"text"="16.6";"absoluteValue"=82.995;"lowerBound"=82.750;"upperBound"=83.250},
@{"text"="16.5";"absoluteValue"=82.495;"lowerBound"=82.250;"upperBound"=82.750},
@{"text"="16.4";"absoluteValue"=81.995;"lowerBound"=81.750;"upperBound"=82.250},
@{"text"="16.3";"absoluteValue"=81.495;"lowerBound"=81.250;"upperBound"=81.750},
@{"text"="16.2";"absoluteValue"=80.995;"lowerBound"=80.750;"upperBound"=81.250},
@{"text"="16.1";"absoluteValue"=80.495;"lowerBound"=80.250;"upperBound"=80.750},
@{"text"="16.0";"absoluteValue"=79.995;"lowerBound"=79.750;"upperBound"=80.250},
@{"text"="15.9";"absoluteValue"=79.495;"lowerBound"=79.250;"upperBound"=79.750},
@{"text"="15.8";"absoluteValue"=78.995;"lowerBound"=78.750;"upperBound"=79.250},
@{"text"="15.7";"absoluteValue"=78.495;"lowerBound"=78.250;"upperBound"=78.750},
@{"text"="15.6";"absoluteValue"=77.995;"lowerBound"=77.750;"upperBound"=78.250},
@{"text"="15.5";"absoluteValue"=77.495;"lowerBound"=77.250;"upperBound"=77.750},
@{"text"="15.4";"absoluteValue"=76.995;"lowerBound"=76.750;"upperBound"=77.250},
@{"text"="15.3";"absoluteValue"=76.495;"lowerBound"=76.250;"upperBound"=76.750},
@{"text"="15.2";"absoluteValue"=75.995;"lowerBound"=75.750;"upperBound"=76.250},
@{"text"="15.1";"absoluteValue"=75.495;"lowerBound"=75.250;"upperBound"=75.750},
@{"text"="15.0";"absoluteValue"=74.995;"lowerBound"=74.750;"upperBound"=75.250},
@{"text"="14.9";"absoluteValue"=74.495;"lowerBound"=74.250;"upperBound"=74.750},
@{"text"="14.8";"absoluteValue"=73.995;"lowerBound"=73.750;"upperBound"=74.250},
@{"text"="14.7";"absoluteValue"=73.495;"lowerBound"=73.250;"upperBound"=73.750},
@{"text"="14.6";"absoluteValue"=72.995;"lowerBound"=72.750;"upperBound"=73.250},
@{"text"="14.5";"absoluteValue"=72.495;"lowerBound"=72.250;"upperBound"=72.750},
@{"text"="14.4";"absoluteValue"=71.995;"lowerBound"=71.750;"upperBound"=72.250},
@{"text"="14.3";"absoluteValue"=71.495;"lowerBound"=71.250;"upperBound"=71.750},
@{"text"="14.2";"absoluteValue"=70.995;"lowerBound"=70.750;"upperBound"=71.250},
@{"text"="14.1";"absoluteValue"=70.495;"lowerBound"=70.250;"upperBound"=70.750},
@{"text"="14.0";"absoluteValue"=69.995;"lowerBound"=69.750;"upperBound"=70.250},
@{"text"="13.9";"absoluteValue"=69.495;"lowerBound"=69.250;"upperBound"=69.750},
@{"text"="13.8";"absoluteValue"=68.995;"lowerBound"=68.750;"upperBound"=69.250},
@{"text"="13.7";"absoluteValue"=68.495;"lowerBound"=68.250;"upperBound"=68.750},
@{"text"="13.6";"absoluteValue"=67.995;"lowerBound"=67.750;"upperBound"=68.250},
@{"text"="13.5";"absoluteValue"=67.495;"lowerBound"=67.250;"upperBound"=67.750},
@{"text"="13.4";"absoluteValue"=66.995;"lowerBound"=66.750;"upperBound"=67.250},
@{"text"="13.3";"absoluteValue"=66.495;"lowerBound"=66.250;"upperBound"=66.750},
@{"text"="13.2";"absoluteValue"=65.995;"lowerBound"=65.750;"upperBound"=66.250},
@{"text"="13.1";"absoluteValue"=65.495;"lowerBound"=65.250;"upperBound"=65.750},
@{"text"="13.0";"absoluteValue"=64.995;"lowerBound"=64.750;"upperBound"=65.250},
@{"text"="12.9";"absoluteValue"=64.495;"lowerBound"=64.250;"upperBound"=64.750},
@{"text"="12.8";"absoluteValue"=63.995;"lowerBound"=63.750;"upperBound"=64.250},
@{"text"="12.7";"absoluteValue"=63.495;"lowerBound"=63.250;"upperBound"=63.750},
@{"text"="12.6";"absoluteValue"=62.995;"lowerBound"=62.750;"upperBound"=63.250},
@{"text"="12.5";"absoluteValue"=62.495;"lowerBound"=62.250;"upperBound"=62.750},
@{"text"="12.4";"absoluteValue"=61.995;"lowerBound"=61.750;"upperBound"=62.250},
@{"text"="12.3";"absoluteValue"=61.495;"lowerBound"=61.250;"upperBound"=61.750},
@{"text"="12.2";"absoluteValue"=60.995;"lowerBound"=60.750;"upperBound"=61.250},
@{"text"="12.1";"absoluteValue"=60.495;"lowerBound"=60.250;"upperBound"=60.750},
@{"text"="12.0";"absoluteValue"=59.995;"lowerBound"=59.750;"upperBound"=60.250},
@{"text"="11.9";"absoluteValue"=59.495;"lowerBound"=59.250;"upperBound"=59.750},
@{"text"="11.8";"absoluteValue"=58.995;"lowerBound"=58.750;"upperBound"=59.250},
@{"text"="11.7";"absoluteValue"=58.495;"lowerBound"=58.250;"upperBound"=58.750},
@{"text"="11.6";"absoluteValue"=57.995;"lowerBound"=57.750;"upperBound"=58.250},
@{"text"="11.5";"absoluteValue"=57.495;"lowerBound"=57.250;"upperBound"=57.750},
@{"text"="11.4";"absoluteValue"=56.995;"lowerBound"=56.750;"upperBound"=57.250},
@{"text"="11.3";"absoluteValue"=56.495;"lowerBound"=56.250;"upperBound"=56.750},
@{"text"="11.2";"absoluteValue"=55.995;"lowerBound"=55.750;"upperBound"=56.250},
@{"text"="11.1";"absoluteValue"=55.495;"lowerBound"=55.250;"upperBound"=55.750},
@{"text"="11.0";"absoluteValue"=54.995;"lowerBound"=54.750;"upperBound"=55.250},
@{"text"="10.9";"absoluteValue"=54.495;"lowerBound"=54.250;"upperBound"=54.750},
@{"text"="10.8";"absoluteValue"=54.000;"lowerBound"=53.750;"upperBound"=54.250},
@{"text"="10.7";"absoluteValue"=53.500;"lowerBound"=53.250;"upperBound"=53.750},
@{"text"="10.6";"absoluteValue"=53.000;"lowerBound"=52.750;"upperBound"=53.250},
@{"text"="10.5";"absoluteValue"=52.500;"lowerBound"=52.250;"upperBound"=52.750},
@{"text"="10.4";"absoluteValue"=52.000;"lowerBound"=51.750;"upperBound"=52.250},
@{"text"="10.3";"absoluteValue"=51.500;"lowerBound"=51.250;"upperBound"=51.750},
@{"text"="10.2";"absoluteValue"=51.000;"lowerBound"=50.750;"upperBound"=51.250},
@{"text"="10.1";"absoluteValue"=50.500;"lowerBound"=50.250;"upperBound"=50.750},
@{"text"="10.0";"absoluteValue"=49.995;"lowerBound"=49.750;"upperBound"=50.250},
@{"text"="09.9";"absoluteValue"=49.495;"lowerBound"=49.250;"upperBound"=49.750},
@{"text"="09.8";"absoluteValue"=48.995;"lowerBound"=48.750;"upperBound"=49.250},
@{"text"="09.7";"absoluteValue"=48.495;"lowerBound"=48.250;"upperBound"=48.750},
@{"text"="09.6";"absoluteValue"=47.995;"lowerBound"=47.750;"upperBound"=48.250},
@{"text"="09.5";"absoluteValue"=47.495;"lowerBound"=47.250;"upperBound"=47.750},
@{"text"="09.4";"absoluteValue"=46.995;"lowerBound"=46.750;"upperBound"=47.250},
@{"text"="09.3";"absoluteValue"=46.495;"lowerBound"=46.250;"upperBound"=46.750},
@{"text"="09.2";"absoluteValue"=45.995;"lowerBound"=45.750;"upperBound"=46.250},
@{"text"="09.1";"absoluteValue"=45.495;"lowerBound"=45.250;"upperBound"=45.750},
@{"text"="09.0";"absoluteValue"=44.995;"lowerBound"=44.750;"upperBound"=45.250},
@{"text"="08.9";"absoluteValue"=44.495;"lowerBound"=44.250;"upperBound"=44.750},
@{"text"="08.8";"absoluteValue"=43.995;"lowerBound"=43.750;"upperBound"=44.250},
@{"text"="08.7";"absoluteValue"=43.495;"lowerBound"=43.250;"upperBound"=43.750},
@{"text"="08.6";"absoluteValue"=42.995;"lowerBound"=42.750;"upperBound"=43.250},
@{"text"="08.5";"absoluteValue"=42.495;"lowerBound"=42.250;"upperBound"=42.750},
@{"text"="08.4";"absoluteValue"=41.995;"lowerBound"=41.750;"upperBound"=42.250},
@{"text"="08.3";"absoluteValue"=41.495;"lowerBound"=41.250;"upperBound"=41.750},
@{"text"="08.2";"absoluteValue"=40.995;"lowerBound"=40.750;"upperBound"=41.250},
@{"text"="08.1";"absoluteValue"=40.495;"lowerBound"=40.250;"upperBound"=40.750},
@{"text"="08.0";"absoluteValue"=39.995;"lowerBound"=39.750;"upperBound"=40.250},
@{"text"="07.9";"absoluteValue"=39.495;"lowerBound"=39.250;"upperBound"=39.750},
@{"text"="07.8";"absoluteValue"=38.995;"lowerBound"=38.750;"upperBound"=39.250},
@{"text"="07.7";"absoluteValue"=38.495;"lowerBound"=38.250;"upperBound"=38.750},
@{"text"="07.6";"absoluteValue"=37.995;"lowerBound"=37.750;"upperBound"=38.250},
@{"text"="07.5";"absoluteValue"=37.495;"lowerBound"=37.250;"upperBound"=37.750},
@{"text"="07.4";"absoluteValue"=36.995;"lowerBound"=36.750;"upperBound"=37.250},
@{"text"="07.3";"absoluteValue"=36.495;"lowerBound"=36.250;"upperBound"=36.750},
@{"text"="07.2";"absoluteValue"=35.995;"lowerBound"=35.750;"upperBound"=36.250},
@{"text"="07.1";"absoluteValue"=35.495;"lowerBound"=35.250;"upperBound"=35.750},
@{"text"="07.0";"absoluteValue"=34.995;"lowerBound"=34.750;"upperBound"=35.250},
@{"text"="06.9";"absoluteValue"=34.495;"lowerBound"=34.250;"upperBound"=34.750},
@{"text"="06.8";"absoluteValue"=33.995;"lowerBound"=33.750;"upperBound"=34.250},
@{"text"="06.7";"absoluteValue"=33.495;"lowerBound"=33.250;"upperBound"=33.750},
@{"text"="06.6";"absoluteValue"=32.995;"lowerBound"=32.750;"upperBound"=33.250},
@{"text"="06.5";"absoluteValue"=32.495;"lowerBound"=32.250;"upperBound"=32.750},
@{"text"="06.4";"absoluteValue"=31.995;"lowerBound"=31.750;"upperBound"=32.250},
@{"text"="06.3";"absoluteValue"=31.495;"lowerBound"=31.250;"upperBound"=31.750},
@{"text"="06.2";"absoluteValue"=30.995;"lowerBound"=30.750;"upperBound"=31.250},
@{"text"="06.1";"absoluteValue"=30.495;"lowerBound"=30.250;"upperBound"=30.750},
@{"text"="06.0";"absoluteValue"=29.995;"lowerBound"=29.750;"upperBound"=30.250},
@{"text"="05.9";"absoluteValue"=29.495;"lowerBound"=29.250;"upperBound"=29.750},
@{"text"="05.8";"absoluteValue"=28.995;"lowerBound"=28.750;"upperBound"=29.250},
@{"text"="05.7";"absoluteValue"=28.495;"lowerBound"=28.250;"upperBound"=28.750},
@{"text"="05.6";"absoluteValue"=27.995;"lowerBound"=27.750;"upperBound"=28.250},
@{"text"="05.5";"absoluteValue"=27.495;"lowerBound"=27.250;"upperBound"=27.750},
@{"text"="05.4";"absoluteValue"=26.995;"lowerBound"=26.750;"upperBound"=27.250},
@{"text"="05.3";"absoluteValue"=26.495;"lowerBound"=26.250;"upperBound"=26.750},
@{"text"="05.2";"absoluteValue"=25.995;"lowerBound"=25.750;"upperBound"=26.250},
@{"text"="05.1";"absoluteValue"=25.495;"lowerBound"=25.250;"upperBound"=25.750},
@{"text"="05.0";"absoluteValue"=24.995;"lowerBound"=24.750;"upperBound"=25.250},
@{"text"="04.9";"absoluteValue"=24.495;"lowerBound"=24.250;"upperBound"=24.750},
@{"text"="04.8";"absoluteValue"=23.995;"lowerBound"=23.750;"upperBound"=24.250},
@{"text"="04.7";"absoluteValue"=23.495;"lowerBound"=23.250;"upperBound"=23.750},
@{"text"="04.6";"absoluteValue"=22.995;"lowerBound"=22.750;"upperBound"=23.250},
@{"text"="04.5";"absoluteValue"=22.495;"lowerBound"=22.250;"upperBound"=22.750},
@{"text"="04.4";"absoluteValue"=21.995;"lowerBound"=21.750;"upperBound"=22.250},
@{"text"="04.3";"absoluteValue"=21.495;"lowerBound"=21.250;"upperBound"=21.750},
@{"text"="04.2";"absoluteValue"=20.995;"lowerBound"=20.750;"upperBound"=21.250},
@{"text"="04.1";"absoluteValue"=20.495;"lowerBound"=20.250;"upperBound"=20.750},
@{"text"="04.0";"absoluteValue"=19.995;"lowerBound"=19.750;"upperBound"=20.250},
@{"text"="03.9";"absoluteValue"=19.495;"lowerBound"=19.250;"upperBound"=19.750},
@{"text"="03.8";"absoluteValue"=18.995;"lowerBound"=18.750;"upperBound"=19.250},
@{"text"="03.7";"absoluteValue"=18.495;"lowerBound"=18.250;"upperBound"=18.750},
@{"text"="03.6";"absoluteValue"=17.995;"lowerBound"=17.750;"upperBound"=18.250},
@{"text"="03.5";"absoluteValue"=17.495;"lowerBound"=17.250;"upperBound"=17.750},
@{"text"="03.4";"absoluteValue"=16.995;"lowerBound"=16.750;"upperBound"=17.250},
@{"text"="03.3";"absoluteValue"=16.495;"lowerBound"=16.250;"upperBound"=16.750},
@{"text"="03.2";"absoluteValue"=15.995;"lowerBound"=15.750;"upperBound"=16.250},
@{"text"="03.1";"absoluteValue"=15.495;"lowerBound"=15.250;"upperBound"=15.750},
@{"text"="03.0";"absoluteValue"=14.995;"lowerBound"=14.750;"upperBound"=15.250},
@{"text"="02.9";"absoluteValue"=14.495;"lowerBound"=14.250;"upperBound"=14.750},
@{"text"="02.8";"absoluteValue"=13.995;"lowerBound"=13.750;"upperBound"=14.250},
@{"text"="02.7";"absoluteValue"=13.495;"lowerBound"=13.250;"upperBound"=13.750},
@{"text"="02.6";"absoluteValue"=13.000;"lowerBound"=12.750;"upperBound"=13.250},
@{"text"="02.5";"absoluteValue"=12.500;"lowerBound"=12.250;"upperBound"=12.750},
@{"text"="02.4";"absoluteValue"=12.000;"lowerBound"=11.750;"upperBound"=12.250},
@{"text"="02.3";"absoluteValue"=11.500;"lowerBound"=11.250;"upperBound"=11.750},
@{"text"="02.2";"absoluteValue"=11.000;"lowerBound"=10.750;"upperBound"=11.250},
@{"text"="02.1";"absoluteValue"=10.500;"lowerBound"=10.250;"upperBound"=10.750},
@{"text"="02.0";"absoluteValue"=10.000;"lowerBound"=09.750;"upperBound"=10.250},
@{"text"="01.9";"absoluteValue"=09.500;"lowerBound"=09.250;"upperBound"=09.750},
@{"text"="01.8";"absoluteValue"=09.000;"lowerBound"=08.750;"upperBound"=09.250},
@{"text"="01.7";"absoluteValue"=08.500;"lowerBound"=08.250;"upperBound"=08.750},
@{"text"="01.6";"absoluteValue"=08.000;"lowerBound"=07.750;"upperBound"=08.250},
@{"text"="01.5";"absoluteValue"=07.500;"lowerBound"=07.250;"upperBound"=07.750},
@{"text"="01.4";"absoluteValue"=07.000;"lowerBound"=06.750;"upperBound"=07.250},
@{"text"="01.3";"absoluteValue"=06.500;"lowerBound"=06.250;"upperBound"=06.750},
@{"text"="01.2";"absoluteValue"=06.000;"lowerBound"=05.750;"upperBound"=06.250},
@{"text"="01.1";"absoluteValue"=05.500;"lowerBound"=05.250;"upperBound"=05.750},
@{"text"="01.0";"absoluteValue"=05.000;"lowerBound"=04.750;"upperBound"=05.250},
@{"text"="00.9";"absoluteValue"=04.500;"lowerBound"=04.250;"upperBound"=04.750},
@{"text"="00.8";"absoluteValue"=04.000;"lowerBound"=03.750;"upperBound"=04.250},
@{"text"="00.7";"absoluteValue"=03.500;"lowerBound"=03.250;"upperBound"=03.750},
@{"text"="00.6";"absoluteValue"=03.000;"lowerBound"=02.750;"upperBound"=03.250},
@{"text"="00.5";"absoluteValue"=02.500;"lowerBound"=02.250;"upperBound"=02.750},
@{"text"="00.4";"absoluteValue"=02.000;"lowerBound"=01.750;"upperBound"=02.250},
@{"text"="00.3";"absoluteValue"=01.500;"lowerBound"=01.250;"upperBound"=01.750},
@{"text"="00.2";"absoluteValue"=01.000;"lowerBound"=00.750;"upperBound"=01.250},
@{"text"="00.1";"absoluteValue"=00.485;"lowerBound"=00.225;"upperBound"=00.750},
@{"text"="00.0";"absoluteValue"=00.110;"lowerBound"=00.000;"upperBound"=00.225}
    )
}

#

$body =$body  | ConvertTo-Json

$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 

Return $Resultadofn
}


Function CALIFICACIONES-PATCH-Columna_Schema{
Param($token,$URL_sitio,$courseId,$columnId, $schemaId)
#CALIFICACIONES-PATCH-Columna_Schema $token $URL_sitio courseId: $columnId $schemaId
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$grading = @{
            "schemaId" = $schemaId;
            }
$score= @{
        "possible" = "0";
         }
$body = @{
         "grading"=$grading;
         "score"  =$score;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 

try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId $columnId > Modificado"
    }
catch{
    $salida="$courseId $columnId > Falló"
    }
Return $Resultadofn
}

Function CALIFICACIONES-GET_Schema{
Param($token,$URL_sitio,$courseId)
#CALIFICACIONES-GET_Schema $token $URL_sitio courseId:

$uri = $URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/gradebook/schemas'

$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

#$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers # | Select-Object -Skip 1 

try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers # | Select-Object -Skip 1 
    $salida="$courseId  > Modificado"
    }
catch{
    $salida="$courseId  > Falló"
    }
Return $Resultadofn.results

}

Function CALIFICACIONES-POST_Schema{
Param($token,$URL_sitio,$courseId)
#CALIFICACIONES-POST_Schema $token $URL_sitio courseId:

$uri = $URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/gradebook/schemas'

$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

$body=@{
  "externalId"="vigesimal";
  "title"="vigesimal";
  "description"="vigesimal";
  "scaleType"="Tabular";
  "symbols"=
   @( 
    @{
      "text"="DESAPROBADO";
      "absoluteValue"=25;
      "lowerBound"=0;
      "upperBound"=55
      },
    @{
      "text"="APROBADO";
      "absoluteValue"=75;
      "lowerBound"=55;
      "upperBound"=100
    }
    )
}

#

$body =$body  | ConvertTo-Json
#$body =[System.Text.Encoding]::UTF8.GetBytes($body)

$Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body  # | Select-Object -Skip 1 

try{
    $Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida="$courseId  > Modificado"
    }
catch{
    $salida="$courseId  > Falló"
    }
Return $Resultadofn 
}


Function CALIFICACIONES_DELETE{
Param ($token,$URL_sitio,$courseId,$columnId,$debug)
#CALIFICACIONES_DELETE $token $URL_sitio courseId contentId

$uri=$URL_sitio+'/learn​/api​/public​/v2​/courses​/'+$courseId+'/gradebook​/columns​/'+$columnId 

write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if ($debug -eq 'Yes')
{Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers
Return
} else
{
try{
$Resultadofn=Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers 
$salida=$courseId + ' - ' +$columnId +' ok'
}
catch{
$salida=$courseId + ' - ' +$columnId +' falló'
}
Return $salida}
} 

