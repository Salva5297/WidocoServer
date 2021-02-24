#!/bin/bash

num_args=$#
array=("$@")
arr=()
contador=0


if [ $num_args -lt 1 ]; then
    echo "Not enough arguments. Type sh widoco.sh -h || --help to get the usage of this application."

elif [ ${array[@]}="-h" ] || [ ${array[@]}="--help" ]; then
	echo " "
            echo "Usage: sh widoco.sh + arguments (arguments below)"
            echo " "
            echo "-ontoFile ontologyFile            -includeImportedOntologies"
            echo "-ontoUri ontologyUri              -htaccess"
            echo "-confFile configurationFile       -webVowl"
            echo "-oops                             -licensius"
            echo "-rewriteAll                       -ignoreIndividuals"
            echo "-crossRef                         -analytics analyticsFile"
            echo "-saveConfig saveFile     	  -doNotDisplaySerializations"
            echo "-usecustomStyle                   -displaydirectImportsOnly"
            echo "-lang lang1-lang2                 -rewriteBase baseFile"
            echo "-excludeIntroduction              -uniteSections"
            break

elif [ $num_args -lt 3 ]; then # mirar a ver si lo que recibe es una uri o un fichero
    curl --location --request POST 'http://127.0.0.1:5000/' --header 'Content-Type: multipart/form-data; boundary=--------------------------554657334890040702125867' --form 'data={"getOntologyMetadata":"","rewriteAll":"","lang":"en"}' --form 'ontoFile=@'$2 --output WidocoDocs.zip

else
    for arg in ${array[@]};
    do
		contador=$contador+1

        if [ "$arg" = "-ontoFile" ]; then
            ontologyFile="${array[$arg+$contador]}" # Get the file of the ontology
            # Add here the data of the ontology and de command
            arr=("ontoFile=@$ontologyFile" "${arr[@]}")
        
        elif [ "$arg" = "-ontoUri" ]; then
            ontologyUri="${array[$arg+$contador]}" # Get the uri of the ontology
            arr=('"ontoUri":"'$ontologyUri'"' "${arr[@]}")

        elif [ "$arg" = "-confFile" ]; then
            configurationFile="${array[$arg+$contador]}" # Get the configuration file that the client want
            arr=("${arr[@]}" '"confFile":"'$configurationFile'"')

        elif [ "$arg" = "-oops" ]; then
            arr=("${arr[@]}" '"oops":""')

        elif [ "$arg" = "-rewriteAll" ]; then
            arr=("${arr[@]}" '"rewriteAll":""')

        elif [ "$arg" = "-crossRef" ]; then
            arr=("${arr[@]}" '"crossRef":""')

        elif [ "$arg" = "-saveConfig" ]; then
            saveFile="${array[$arg+$contador]}" # Save the configuration into one file
            arr=("${arr[@]}" '"saveConfig":"'$saveFile'"')

        elif [ "$arg" = "-usecustomStyle" ]; then
            arr=("${arr[@]}" '"usecustomStyle":""')

        elif [ "$arg" = "-lang" ]; then
            languages="${array[$arg+$contador]}" # Get the languages that the client want
            arr=("${arr[@]}" '"lang":"'$languages'"')

        elif [ "$arg" = "-excludeIntroduction" ]; then
            arr=("${arr[@]}" '"excludeIntroduction":""')

        elif [ "$arg" = "-includeImportedOntologies" ]; then
            arr=("${arr[@]}" '"includeImportedOntologies":""')

        elif [ "$arg" = "-htaccess" ]; then
            arr=("${arr[@]}" '"htaccess":""')

        elif [ "$arg" = "-webVowl" ]; then
            arr=("${arr[@]}" '"webVowl":""')

        elif [ "$arg" = "-licensius" ]; then
            arr=("${arr[@]}" '"licensius":""')

        elif [ "$arg" = "-ignoreIndividuals" ]; then
            arr=("${arr[@]}" '"ignoreIndividuals":""')

        elif [ "$arg" = "-analytics" ]; then
            analyticsFile="${array[$arg+$contador]}" # Get the analytics file that the client want
            arr=("${arr[@]}" '"analytics":"'$analyticsFile'"')

        elif [ "$arg" = "-doNotDisplaySerializations" ]; then
            arr=("${arr[@]}" '"doNotDisplaySerializations":""')

        elif [ "$arg" = "-displaydirectImportsOnly" ]; then
            arr=("${arr[@]}" '"displaydirectImportsOnly":""')

        elif [ "$arg" = "-rewriteBase" ]; then
            baseFile="${array[$arg+$contador]}" # Get the base file that the client want
            arr=("${arr[@]}" '"rewriteBase":"'$baseFile'"')

        elif [ "$arg" = "-uniteSections" ]; then
            arr=("${arr[@]}" '"uniteSections":""')

        else
            continue
        fi
    done

	data=${arr[0]}
	arrIN=(${data//=/ })
	if [ $arrIN == "ontoFile" ]; then
		unset 'arr[0]'
		json=("${arr[@]}")
		json=$(printf ",%s" "${json[@]}")
		json=${json:1}
	
		curl --location --request POST 'http://127.0.0.1:5000/' --header 'Content-Type: multipart/form-data; boundary=--------------------------554657334890040702125867' --form 'data={'$json'}' --form $data --output WidocoDocs.zip
	else
		json=("${arr[@]}")
		json=$(printf ",%s" "${json[@]}")
		json=${json:1}
		curl --location --request POST 'http://127.0.0.1:5000/' --header 'Content-Type: multipart/form-data; boundary=--------------------------554657334890040702125867' --form 'data={'$json'}' --output WidocoDocs.zip
	fi
fi
