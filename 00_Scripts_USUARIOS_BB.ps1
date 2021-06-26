Function USUARIO_GET-Todos{
Param($token,$URL_sitio,$centenas,$pathUsuarios)
#### $centenas es el número de usuarios dividido entre 100 ---la cantidad de usuario se ve en el panel de administración
    Set-Content -Path $pathUsuarios -Value ''
    For ($i=1; $i -le $centenas; $i++){
        $desvio=[int]($i-1)*100
        $uri=$URL_sitio+'/learn/api/public/v1/users?fields=id,userName,studentId&offset='+$desvio
        $headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
                    }
        $Resultado=(Invoke-RestMethod -Uri $uri -Method Get -Headers $headers ).results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathUsuarios 
        }
    Return "Listado de usuarios $pathUsuarios creada"
}

Function USUARIO_GET-Todos_p1{
Param($token,$URL_sitio,$offset,$pathUsuarios)
#USUARIO_GET-Todos_p1 $token $URL_sitio 1 lista_usuuarios.csv
    $headers = @{
        "Authorization"="Bearer "+ $token;
        "Content-Type"="application/json";
                }
    if ($offset -eq '1'){
        $uri=$URL_sitio+'/learn/api/public/v1/users?fields=id%2CuserName%2CstudentId'  #&offset=136400'
        Set-Content -Path $pathUsuarios -Value ''
        } else
        {
        $uri=$URL_sitio+$offset
        }
    $Resultado=(Invoke-RestMethod -Uri $uri -Method Get -Headers $headers )
    $Resultado.results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathUsuarios 
    $NuevoEndPoint=$Resultado.paging.nextpage
    if ($NuevoEndPoint.length -gt 1) {
        USUARIO_GET-Todos_p1 $token $URL_sitio $NuevoEndPoint $pathUsuarios
        }
    Return "Listado de usuarios $pathUsuarios creada"
}

Function USUARIO_GET-Rerporte{
Param ($token,$URL_sitio,$desvio,$limite,$debug) #id es el código clave del curso para APIs (por ej. _23_1)
#CURSO_GET $token $URL_sitio $courseId $debug
$pathUsuario='D:\__Ricardo\EXT_DIR\BB_Usuarios\'
$pathReporte=$pathUsuario+'APIRptUsuario'+$desvio+'.txt'
$uri=$URL_sitio+'/learn/api/public/v1/users/?fields=id,userName,externalId,studentId,name.family,name.given,availability.available,lastLogin&offset='+$desvio+'&limit=100'

$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }

Set-Content -Path $pathReporte -Value ''
$Resultadofn=Invoke-RestMethod -Uri $uri -Method get -Headers $headers
write-output $Resultadofn.Results | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $pathReporte
Return 
}

Function USUARIO_GET-uno{
Param($token,$URL_sitio,$userName)
        $uri=$URL_sitio+'/learn/api/public/v1/users/'+$userName
        $headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
                    }
        $Resultado=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
    Return $Resultado
}

Function USUARIO_DELETE-uno{
Param($token,$URL_sitio,$userName)
        $uri=$URL_sitio+'/learn/api/public/v1/users/'+$userName
        $headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
                    }
    try{$Resultado=Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers 
    Return 'Eliminado'} 
    catch{
    Return 'No se eliminó'
    }
}

Function USUARIO_GET-studentId{
Param($token,$URL_sitio,$userName) #####$externalUserId
        $uri=$URL_sitio+'/learn/api/public/v1/users/'+$userName+'#?fields=userName,studentId'
        $headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
                    }
        $Resultado=Invoke-RestMethod -Uri $uri -Method Get -Headers $headers 
    Return $Resultado
}

Function USUARIO_PATCH-ID_csv{  ##USUARIO_PATCH-ID_csv $token $URL_sitio usuarios_correo_ID.csv
Param($token,$URL_sitio,$pathUsuarios) #####El archivo debe tener 2 columnas: userName e ID_SINFO
    Import-Csv $pathUsuarios | Foreach-Object { 
        foreach ($property in $_.PSObject.Properties)
        {   if($property.Name -eq 'userName'){$userName='userName:'+$property.Value}
            if($property.Name -eq 'ID_SINFO')
                    {$i++ 
                     $studentId=$property.Value 
                     $uri=$URL_sitio+'/learn/api/public/v1/users/'+$userName
                     #WRITE-OUTPUT $uri
                     $bodyupdate=@{
                                externalId=$studentId;
                                studentId=$studentId;
                                } | ConvertTo-Json
                     $headers = @{
                            "Authorization"="Bearer "+ $token;
                            "Content-Type"="application/json";
                                }
                     try{
                        $Resultado=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $bodyupdate
                        $salida=$studentId + ' > actualizado ('+$i+')'
                        }
                     catch{
                        $salida=$studentId + ' > falló ('+$i+')'
                        }
                     write-output $salida
                     }
         }
    }
    Return 'Actualización terminada' 
}
    

Function USUARIO_PATCH-ID_ApeyNom_csv{
Param($token,$URL_sitio,$pathUsuarios)#archivo CSV pk1,batch_uid,ID_SINFO,apellidos,nombres,correo_login,correo_comunicacion
#USUARIO_PATCH-ID_ApeyNom_csv $token $URL_sitio usuarios.csv
    $i=0
    Import-Csv $pathUsuarios | Foreach-Object { 
            foreach ($property in $_.PSObject.Properties)
            {
            if($property.Name -eq 'pk1'){$pk1=$property.Value}
            if($property.Name -eq 'batch_uid'){$batch_uid=$property.Value}
            if($property.Name -eq 'ID_SINFO'){$ID_alumno=$property.Value}
            if($property.Name -eq 'apellidos'){$Apellidos=$property.Value}
            if($property.Name -eq 'nombres'){$Nombres=$property.Value}
            if($property.Name -eq 'correo_login'){$correo_login=$property.Value}
            if(($property.Name -eq 'correo_comunicacion') -and ($i -ge 0)){             #-ge 0 es para cambiar por otro número en caso de debug
                        $i++
                        $correo_comunicacion=$property.Value
                        $uri=$URL_sitio+'/learn/api/public/v1/users/'+$pk1
                        $name=@{
                                "given"=$Nombres;
                                "family"=$Apellidos;
                                }
                        $contact=@{
                                "email"=$correo_comunicacion;
                                 }
                        $body=@{
                                "externalId"=$batch_uid;
                                "dataSourceId"='_2_1';
                                "userName"=$correo_login;
                                "studentId"=$ID_alumno;
                                "name"=$name;
                                "contact"=$contact;
                                    } 
                        $body=$body| ConvertTo-Json
                        #write-output $body
                        $body =[System.Text.Encoding]::UTF8.GetBytes($body)
                        $headers = @{
                            "Authorization"="Bearer "+ $token;
                            "Content-Type"="application/json";
                                }
                        #write-output $uri
                        #$mensaje="$($ID_alumno)  actualizado ($($i))"    
                        #write-output $mensaje
                        Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
                        return
                        try{
                            $Resultado=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
                            $mensaje="$($ID_alumno)  actualizado ($($i))"    
                            }
                        catch{
                            $mensaje="$($ID_alumno)  falló       ($($i))"
                            }
                        write-output $mensaje
                    }
            }
    }
    Return 'Actualización terminada'
}




Function USUARIO_PATCH-ExternalID_UserName{
Param($token,$URL_sitio,$pk1,$ID,$correo)#archivo CSV pk1,ID_SINFO,apellidos,nombres,correo
#USUARIO_PATCH-ExternalID_UserName $token $URL_sitio $pk1 $ID $correo
                        $uri=$URL_sitio+'/learn/api/public/v1/users/'+$pk1
                        $body=@{
                                "externalId"=$ID;
                                "userName"=$Correo;
                                    } 
                        $body=$body| ConvertTo-Json
                        #write-output $body
                        $body =[System.Text.Encoding]::UTF8.GetBytes($body)
                        $headers = @{
                            "Authorization"="Bearer "+ $token;
                            "Content-Type"="application/json";
                                }
                        #write-output $uri
                        #$mensaje="$($ID_alumno)  actualizado ($($i))"    
                        #write-output $mensaje
                        
                        try{
                            $Resultado=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
                            $mensaje="$($ID_alumno)  actualizado ($($i))"    
                            }
                        catch{
                            $mensaje="$($ID_alumno)  falló       ($($i))"
                            }
                        write-output $mensaje
    Return 'Actualización terminada'
}


Function USUARIO_PATCH-ExternalID{
Param($token,$URL_sitio,$pk1,$ID)
                        $uri=$URL_sitio+'/learn/api/public/v1/users/'+$pk1
                        $body=@{
                                "externalId"=$ID;
                                    } 
                        $body=$body| ConvertTo-Json
                        #write-output $body
                        $body =[System.Text.Encoding]::UTF8.GetBytes($body)
                        $headers = @{
                            "Authorization"="Bearer "+ $token;
                            "Content-Type"="application/json";
                                }
                        try{
                            $Resultado=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
                            $mensaje="$($ID)  actualizado "    
                            }
                        catch{
                            $mensaje="$($ID)  falló"
                            }
                        write-output $mensaje
    Return 'Actualización terminada'
}


Function USUARIO_PATCH-VisibleYN{
Param ($token,$URL_sitio,$userId,$activoYesNo,$debug) 
$uri=$URL_sitio+'/learn/api/public/v1/users/'+$userId
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$availability=@{
    "available"=$activoYesNo
    }
$body = @{
  "availability"=$availability;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$salida='Sin respuesta'
if ($activoYesNo -eq 'Yes'){
    $estado = 'Habilitado'
    } else
    {
    $estado = 'Inhabilitado'
    }
if ($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    return} else 
    {
    try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$userId +' > '+$estado}
    catch{
    #Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    $salida=$userId +' > Falló habilitación'
    }
    }
Return $salida
}

Function USUARIO_POST-Crear{
Param ($token,$URL_sitio,$correo_login,$apellidos,$nombres,$id,$pass,$correo_comunicacion,$debug) 
$uri=$URL_sitio+'/learn/api/public/v1/users'
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$studentId=([string]$id).PadLeft(9,'0')
#write-output $studentId
$name=@{
    "given"=$nombres;
    "family"=$apellidos;
    }
$contact=@{
    "email"=$correo_comunicacion;
    }
$availability=@{
    "available"= 'Yes'
    }
$body = @{
  "externalId"= $studentId;
  "dataSourceId"='_2_1';
  "userName"= $correo_login;
  "studentId"=$studentId;
  "password"=$pass;
  "availability"=$availability;
  "name"=$name;
  "contact"=$contact
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
if ($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body # 
    return} 
 else {
    try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body # | Select-Object -Skip 1 
    $salida=$studentId +' > Creado'}
    catch{
    $salida=$studentId +' > Falló'
    }
    Return $salida
    }
}

