# Localized PlasterResources.psd1

ConvertFrom-StringData @'
###PSLOC
ErrorFailedToLoadStoreFile_F1=Impossible de charger, depuis le magasin, le fichier des valeurs par défaut : '{0}'.
ErrorProcessingDynamicParams_F1=Erreur lors du traitement des paramètres dynamiques : '{0}'.
ErrorTemplatePathIsInvalid_F1=La valeur du paramètre TemplatePath doit être un nom de répertoire existant. Le chemin spécifié '{0}' ne fonctionne pas.
ErrorUnencryptingSecureString_F1=Impossible de décrypter la valeur pour le paramètre :'{0}'.
ErrorPathDoesNotExist_F1=Le chemin '{0}' n'existe pas.
ErrorPathMustBeRelativePath_F2=le chemin '{0}' indiqué dans la directive {1} du fichier manifeste ne peut être un nom de chemin absolu. Modifiez-le par un nom de chemin relatif.
ErrorPathMustBeUnderDestPath_F2=Le chemin '{0}' doit être un sous répertoire de DestinationPath '{1}'.
FileConflict= Conflit de fichiers Plaster détecté
ManifestFileMissing_F1=Le fichier manifeste de Plaster '{0}' est introuvable.
ManifestMissingDocElement_F2=L'élément <plasterManifest xmlns = "{1}"> </ plasterManifest> est manquant dans le fichier manifeste de Plaster '{0}'
ManifestMissingDocTargetNamespace_F2=Le fichier de manifeste Plaster '{0}' est manquant ou a un espace de noms cible invalide sur l'élément de document. Vous devez le spécifier en tant que <plasterManifest xmlns="{1}"></plasterManifest>.
ManifestSchemaValidationError_F1=Erreur de validation de schéma pour le manifeste de Plaster : {0}
ManifestSchemaVersionNotSupported_F1=La version du schéma du manifeste de modèle ({0}) nécessite une nouvelle version de Plaster. Mettez-le à jour et réessayez.
ManifestErrorReading_F1=Erreur lors de la lecture du manifeste de Plaster : {0}
ManifestNotValid_F1=Le manifeste de Plaster '{0}' est invalide. Spécifiez le paramètre -Verbose pour afficher le détail des erreurs de validation de schéma.
ManifestNotWellFormedXml_F2=Le fichier de manifeste de Plaster '{0}' est mal formé, sa syntaxe est incorrecte : {1}
ManifestWrongFilename_F1=Le nom du fichier de manifeste '{0}' est invalide. La valeur de l'argument Path doit référencer un fichier nommé 'plasterManifest.xml'. Renommez le fichier de manifeste de Plaster et réessayez.
NewModManifest_CreatingDir_F1=Création du répertoire de destination pour le manifeste de module : {0}
OpCreate=Création
OpConflict=Conflit
OpIdentical=Identiques
OpModify=Modification
 #TYPO
OForce=Force

OpUpdate=Actualisation
OverwriteFile_F1=Remplace {0}
TempFileOperation_F1={0} dans un fichier temporaire
TempFileTarget_F1=fichier temporaire pour '{0}'
ParameterTypeChoiceMultipleDefault_F1=Le paramètre nommé {0} est du type 'choice', il ne peut avoir qu'une seule valeur.
ShouldProcessCreateDir=Crée le répertoire
ShouldProcessExpandTemplate=Transformation du fichier de modèle
ShouldProcessGenerateModuleManifest=Génère un nouveau manifeste de module
SubsitutionExpressionInvalid_F1=L'expression de substitution '{0}' n'est pas pris en charge. Seules les chaines constantes contenant ou non des expressions de variable sont prises en charge.
UnrecognizedParametersElement_F1=Un élément enfant de l'élément 'parameters' est inconnu : {0}.
UnrecognizedParameterType_F2=Le type de paramètre '{0}' est inconnu sur le paramètre nommé '{1}'.
UnrecognizedContentElement_F1=Le contenu d'un élément enfant du manifeste est inconnu : {0}.
###PSLOC
'@
