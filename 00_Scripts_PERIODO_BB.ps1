Function PERIODO_POST-Crear{
Param ($token,$URL_sitio,$termName,$termId,$inicio,$fin) 
#### $courseId puede ser _25_1 o couseId:202010-AMOD-107_NRC1526
#### $userName puede ser _5_1 o userId:rtoro@senati.pe
$uri=$URL_sitio+'/learn/api/public/v1/terms'
$externalId=$termId
$name=$termName
$dataSourceId='_2_1'
$duration=@{
      type='DateRange';
      start=$inicio +'T00:00:00.000Z';
      end=$fin +'T23:59:59.999Z';
    }
$availability=@{
    available="Yes";
    duration=$duration
}
$body = @{
           externalId=$externalId
           name=$name
           dataSourceId=$dataSourceId
           availability= $availability;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
#Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $body
#return
try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
    $Resultadofn="$termName > ok"}
catch{
    $Resultadofn="$termName > falló"
    }
Return $Resultadofn
}


Function PERIODO_PATCH-NombreFechas{
Param ($token,$URL_sitio,$termPK1,$termId,$termName,$inicio,$fin) 
#### $courseId puede ser _25_1 o couseId:202010-AMOD-107_NRC1526
#### $userName puede ser _5_1 o userId:rtoro@senati.pe
$uri=$URL_sitio+'/learn/api/public/v1/terms/'+$termPK1
$externalId=$termId
$name=$termName
$duration=@{
      type='DateRange';
      start=$inicio;
      end=$fin ;
    }
$availability=@{
    available="Yes";
    duration=$duration
}
$body = @{
           name=$name
           externalId=$externalId
           availability= $availability;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    $Resultadofn="$termName > ok"}
catch{
    $Resultadofn="$termName > falló"
    }
Return $Resultadofn
}

Function PERIODO_PATCH-Disponible{
Param ($token,$URL_sitio,$termPK1) 
#### $courseId puede ser _25_1 o couseId:202010-AMOD-107_NRC1526
#### $userName puede ser _5_1 o userId:rtoro@senati.pe
$uri=$URL_sitio+'/learn/api/public/v1/terms/'+$termPK1
$availability=@{
    available="Yes";
}
$body = @{
           name=$name
           externalId=$externalId
           availability= $availability;
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    $Resultadofn="$termPK1 > ok"}
catch{
    $Resultadofn="$termPK1 > falló"
    }
Return $Resultadofn
}