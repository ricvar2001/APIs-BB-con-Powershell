

Function CLONAR_POST-Curso{
Param ($token,$URL_sitio,$courseId_Origen,$courseId_Destino,$debug)
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId_Origen+'/copy'
$targetCourse= @{
            "courseId"=$courseId_Destino;
            }
$settings= @{
            "availability"="true";
            "bannerImage"="true";
            "duration"="true";
            "enrollmentOptions"="true";
            "guestAccess"="true";
            "languagePack"="true";
            "navigationSettings"="true";
            "observerAccess"= "true";    
            }
$copy= @{
            "adaptiveReleaseRules"= "true";
            "announcements"="false";
            "assessments"="true";
            "blogs"="true";
            "calendar"="true";
            "contacts"="true";
            "contentAlignments"="true";
            "contentAreas"="true";
            "discussions"= "ForumsAndStarterPosts";
            "glossary"="true";
            "gradebook"="true";
            "groupSettings"="true";
            "journals"="true";
            "retentionRules"="true";
            "rubrics"="true";
            "settings"=$settings;
            "tasks"= "true";
            "wikis"= "true";
            }
$body = @{
        "targetCourse"=$targetCourse;
        "copy"=$copy
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
if ($debug -eq 'Yes'){
    Invoke-RestMethod -Uri $uri -Method Post -Headers $headers  -Body $Body
    } else {
    try{$Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers  -Body $Body
        $Resultadofn =$courseId_Destino+ ' ok'}
    catch{$Resultadofn =$courseId_Destino+ ' falló'}
    Return $Resultadofn
    }
}


Function COPIAR_POST-ContenidoCurso{
Param ($token,$URL_sitio,$courseId_Origen,$courseId_Destino_PK1)
#COPIAR_POST-ContenidoCurso $token $URL_sitio $courseId_Origen $courseId_Destino_PK1
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId_Origen+'/copy'
write-output $uri
$targetCourse= @{
            "id"=$courseId_Destino_PK1;
            }
$settings= @{
            "availability"="true";
            "bannerImage"="true";
            "duration"="true";
            "enrollmentOptions"="true";
            "guestAccess"="true";
            "languagePack"="true";
            "navigationSettings"="true";
            "observerAccess"= "true";    
            }
$copy= @{
            "adaptiveReleaseRules"= "true";
            "announcements"="false";
            "assessments"="true";
            "blogs"="true";
            "calendar"="true";
            "contacts"="true";
            "contentAlignments"="true";
            "contentAreas"="true";
            "discussions"= "ForumsAndStarterPosts";
            "glossary"="true";
            "gradebook"="true";
            "groupSettings"="true";
            "journals"="true";
            "retentionRules"="true";
            "rubrics"="true";
            "settings"=$settings;
            "tasks"= "true";
            "wikis"= "true";
            }
$body = @{
        "targetCourse"=$targetCourse;
        "copy"=$copy
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
#$Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers  -Body $Body
Invoke-RestMethod -Uri $uri -Method Post -Headers $headers  -Body $Body
Return #$Resultadofn
}


Function COPIAR_POST-SoloTest{
Param ($token,$URL_sitio,$courseId_Origen,$coursePK1_Destino)
$uri=$URL_sitio+'/learn/api/public/v2/courses/'+$courseId_Origen+'/copy'
write-output $uri
$targetCourse= @{
            "id"=$coursePK1_Destino;
            }
$copy= @{
            "adaptiveReleaseRules"= "true";
            "announcements"="false";
            "assessments"="true";
            "blogs"="true";
            "calendar"="true";
            "contacts"="true";
            "contentAlignments"="true";
            "contentAreas"="true";
            "discussions"= "ForumsAndStarterPosts";
            "glossary"="true";
            "gradebook"="true";
            "groupSettings"="true";
            "journals"="true";
            "retentionRules"="true";
            "rubrics"="true";
            "tasks"= "true";
            "wikis"= "true";
            }
$body = @{
        "targetCourse"=$targetCourse;
        "copy"=$copy
        }
$body =$body  | ConvertTo-Json
$body =[System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{
            "Authorization"="Bearer "+ $token;
            "Content-Type"="application/json";
            }
$Resultadofn=Invoke-RestMethod -Uri $uri -Method Post -Headers $headers  -Body $Body
Return $Resultadofn
}

