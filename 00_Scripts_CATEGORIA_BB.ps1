Function CATEGORIA_POST-Crear-csv{
Param($token,$URL_sitio,$pathCategorias) 
#####El archivo debe tener estas columnas: parentId,categoryId,title
    $i=0
    Import-Csv $pathCategorias | Foreach-Object { 
        foreach ($property in $_.PSObject.Properties)
        {   if($property.Name -eq 'parentId'){$parentId=$property.Value}
            if($property.Name -eq 'categoryId'){$categoryId=$property.Value}
            if($property.Name -eq 'title')
                {$i++
                if($i -ne 1){
                $title=$property.Value
                $uri=$URL_sitio+'/learn/api/public/v1/catalog/categories/Course'
                $bodyupdate=@{
                        parentId=$parentId;
                        categoryId=$categoryId;
                        title=$title
                        available="true"
                        restricted="false"
                        } | ConvertTo-Json
                $headers = @{
                    "Authorization"="Bearer "+ $token;
                    "Content-Type"="application/json";
                        }
                try{
                $Resultado=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $bodyupdate
                $salida=$categoryId + ' > Creado ('+$i+')'
                }
                catch{
                $salida=$categoryId + ' > falló ('+$i+')'
                }
                write-output $salida
                }
                }
         }
    }
    Return 'Actualización terminada' 
}
    

