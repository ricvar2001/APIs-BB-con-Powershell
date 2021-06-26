Function CONTENIDO-GET-PorCurso{
Param ($token,$URL_sitio,$courseId) 
$uri=$URL_sitio+'/learn/api/public/v1/courses/courseId:'+$courseId+'/contents'
write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers # | Select-Object -Skip 1 
Return $Resultadofn.Results
}

Function CONTENIDO-PATCH_Visibilidad{
Param ($token,$URL_sitio,$courseId,$contenidoId,$Visibilidad,$startDate,$endDate) #id es el código clave del curso para APIs (por ej. _23_1)
#CONTENIDO-PATCH_Visibilidad $token $URL_sitio $courseId $contenidoId $Visibilidad
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contenidoId
#write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$adaptiveRelease=@{
            "start"=$startDate;
            "end"= $endDate;
                    }
$availability=@{
                "available"=$Visibilidad
                }
#                "adaptiveRelease"=$adaptiveRelease
$body = @{
        "availability"=$availability
        }
$body =$body  | ConvertTo-Json
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body 
Return "$courseId - $contenidoId Habilitado $Visibilidad"
}

Function CONTENIDO-PATCH-Vencimiento{
Param ($token,$URL_sitio,$courseId,$columnId,$vencimiento) 
$uri=$URL_sitio+'/learn/api/public/v2/courses/courseId:'+$courseId+'/gradebook/columns/'+$columnId
write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$grading=@{
            "due"=$vencimiento;
            }
$body = @{
        "grading"=$grading;
        }
#$body = @{
#    "name"= "Trabajo final del alumno";
#    "description"= "Este trabajo debe tener 3 revisiones a los largo del curso";
#    }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
Return $Resultadofn
}


Function CONTENIDO-PATCH-VencimientoIntentos{
Param ($token,$URL_sitio,$courseId,$columnId,$vencimiento,$intentos) 
#CONTENIDO-PATCH-VencimientoIntentos $token $URL_sitio $courseId $columnId $vencimiento $intentos
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId+'/gradebook/columns/'+$columnId
write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$grading=@{
            "due"=$vencimiento;
            "attemptsAllowed"=$intentos;
            }
$body = @{
        "grading"=$grading;
        }
#$body = @{
#    "name"= "Trabajo final del alumno";
#    "description"= "Este trabajo debe tener 3 revisiones a los largo del curso";
#    }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
Return $Resultadofn
}


Function CONTENIDO_PATCH-Disponibilidad{
Param ($token,$URL_sitio,$courseId,$contentId,$disponibilidadYN,$Debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CONTENIDO_PATCH-Disponibilidad $token $URL_sitio courseId contentId disponibilidadYN
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contentId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$avaliability= @{
            "available"=$disponibilidadYN
            }
$body = @{
        "availability"=$availability
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
$salida=$courseId + ' - ' +$contentId +' ok'
}
catch{
$salida=$courseId + ' - ' +$contentId +' falló'
}
Return $salida}
} 


Function CONTENIDO_POST-Folder{
Param ($token,$URL_sitio,$courseId,$title,$position,$availability,$debug)
#CONTENIDO_POST-Folder $token $URL_sitio courseId:PARCHE-SPSU-856 'Autoevaluaciones' -1 Yes Yes 
# -1 significa que va al final
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents'
write-output $uri
$availability= @{
            "available"= "Yes"
            }
$contentHandler= @{
            "id"= "resource/x-bb-folder";
           }
if($position -eq -1){
            $body = @{
                      "title"= $title;
                      "launchInNewWindow"= "false";
                      "reviewable"= "true";
                      "availability"=$availability
                      "contentHandler"=$contentHandler
                     }
             } else {
            $body = @{
                      "title"= $title;
                      "position"= $position;
                      "launchInNewWindow"= "false";
                      "reviewable"= "true";
                      "availability"=$availability
                      "contentHandler"=$contentHandler
                     }
             }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if ($debug -eq 'Yes')
{Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body
Return
} else
{
try{
$Resultadofn=Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $body 
$salida=$courseId + ' - ' +$title +' ok'
}
catch{
$salida=$courseId + ' - ' +$title +' falló'
}
Return $salida}
} 

Function CONTENIDO_PATCH-MoverExacto{
Param ($token,$URL_sitio,$courseId,$contentId,$parentId,$position,$debug)
#CONTENIDO_PATCH-Mover $token $URL_sitio $courseId $contentId $parentId $position $debug
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contentId
#write-output $uri
            $body = @{
                      "parentId"= $parentId;
                      "position"= $position
                     }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if ($debug -eq 'Yes')
{Invoke-RestMethod -Uri $uri -Method PATCH -Headers $headers -Body $body
Return
} else
{
try{
$Resultadofn=Invoke-RestMethod -Uri $uri -Method PATCH -Headers $headers -Body $body 
$salida=$courseId + ' - ' +$title +' ok'
}
catch{
$salida=$courseId + ' - ' +$title +' falló'
}
Return $salida}
} 


Function CONTENIDO_PATCH-MoverAlFinal{
Param ($token,$URL_sitio,$courseId,$contentId,$parentId,$debug)
#CONTENIDO_PATCH-Mover $token $URL_sitio $courseId $contentId $parentId $position $debug
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contentId
#write-output $uri
            $body = @{
                      "parentId"= $parentId;
                     }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if ($debug -eq 'Yes')
{Invoke-RestMethod -Uri $uri -Method PATCH -Headers $headers -Body $body
Return
} else
{
try{
$Resultadofn=Invoke-RestMethod -Uri $uri -Method PATCH -Headers $headers -Body $body 
$salida=$courseId + ' - ' +$title +' ok'
}
catch{
$salida=$courseId + ' - ' +$title +' falló'
}
Return $salida}
} 



Function CONTENIDO_DELETE{
Param ($token,$URL_sitio,$courseId,$contentId,$debug)
#CONTENIDO_DELETE $token $URL_sitio courseId contentId
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contentId    #+'?allowChildCourseContent=True'
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
$salida=$courseId + ' - ' +$contentId +' ok'
}
catch{
$salida=$courseId + ' - ' +$contentId +' falló'
}
Return $salida}
} 

Function CONTENIDO_PATCH-Titulo{
Param ($token,$URL_sitio,$courseId,$contentId,$titulo,$Debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CONTENIDO_PATCH-Titulo $token $URL_sitio courseId:PARCHE-SPSU-857 _1843949_1 'Evaluación U03' Yes
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contentId
#write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$avaliability= @{
            "available"=$disponibilidadYN
            }
$body = @{
            "title"= $titulo;
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
$salida=$courseId + ' - ' +$contentId +' ok'
}
catch{
$salida=$courseId + ' - ' +$contentId +' falló'
}
Return $salida}
} 