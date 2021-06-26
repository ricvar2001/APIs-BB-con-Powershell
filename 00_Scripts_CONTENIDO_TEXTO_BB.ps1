Function CONTENIDO-PATCH_EntregaActividad{
Param ($token,$URL_sitio,$courseId,$contenidoId,$titulo,$enlace) #id es el código clave del curso para APIs (por ej. _23_1)
$uri=$URL_sitio+'/learn/api/public/v1/courses/'+$courseId+'/contents/'+$contenidoId
#write-output $uri
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$cuerpo1='<!-- {\"bbMLEditorVersion\":1} --><div data-bbid="\&quot;bbml-editor-id_9c6a9556-80a5-496c-b10d-af2a9ab22d45\">'
$cuerpo2a='<br><strong>Estimado estudiante.</strong><br>'
$cuerpo2b='<ul><li>La <a href="https://senatipe-my.sharepoint.com/:w:/g/personal/materiales_utda_senati_pe/'+$enlace+'" target="_blank" rel="noreferrer noopener">Actividad Entregable</a> debe tener una carátula y ser realizada de forma personal.</li>'
$cuerpo2c='<li>Las copias de tareas serán penalizadas con NOTA DESAPROBATORIA (00).</li>'
$cuerpo2d='<li>Revise su ortografía, la puntuación, entre otros detalles.</li>'
$cuerpo2e='<li>El archivo a subir debe tener un peso máximo de 5Mb, en caso que tenga una capacidad superior se debe convertir en formato PDF.</li></ul>'
$cuerpo2f='<br><strong>PASOS PARA SUBIR MI ACTIVIDAD:</strong><br>'
$cuerpo2g='<ul><li>Ir a la sección <strong>entrega de actividad</strong>.</li>'
$cuerpo2h='<li>Clic en el botón <strong>examinar mi equipo</strong>.</li>'
$cuerpo2i='<li>Busque su tarea y adjúntela.</li>'
$cuerpo2j='<li>Presione el botón <strong>ENVIAR</strong>.</li></ul>'
$cuerpo2k='</div>"'
$cuerpo3='</div>'
$cuerpo = $cuerpo1 + $cuerpo2a + $cuerpo2b + $cuerpo2c+ $cuerpo2d+ $cuerpo2e+ $cuerpo2f+ $cuerpo2g+ $cuerpo2h+ $cuerpo2i+ $cuerpo2j+ $cuerpo2k+ $cuerpo3
$body = @{
        "body"=$cuerpo;
        "title"=$titulo
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body 
Return "$courseId - $contenidoId Habilitado"
}


