#!/bin/bash

rutas="/bin /usr/bin /sbin/ /usr/sbin"
$registro="/snapshot/registro_temp.txt"
find $rutas -type f -printf '%m ' -exec md5sum {} \; > $registro  2>/dev/null


#La opción -c muestra toda la lista de los fichero y marca con:
# ! archivo que han cambiado (aparecerán dos)
# + Archivos añadidos
# - Archivos eliminados
# El grep filtra y obtiene todas la coincidencias que empieze por alguno de esos símbolos
perm_prov='x'
cont_prov='x'


diff -c /snapshot/registro.txt /snapshot/registro_temp.txt | grep -e "^[!+-] " | sort -t" " -k4 |
while read opc permisos md5 archivo
do
	case "$opc" in	
		"+")
			echo "Archivo añadido :: $archivo ";;
		"-")
			echo "Archivo borrado :: $archivo";;
		"!")
#           echo "Archivo modificado :: $archivo :: $permisos :: $md5"
#            echo "$archivo"
		    if [[ $perm_prov == 'x' ]] || [[ $cont_prov == 'x' ]]
		    then
		   	    perm_prov=$permisos;
    		   	cont_prov=$md5;
		    else
				echo "Archivo modificado :: $archivo ";
				[[ $perm_prov != $permisos ]] && echo "  Permisos :: $perm_prov :: $permisos";
				[[ $cont_prov != $md5 ]] && echo "  Contenido :: $cont_prov :: $md5";
				perm_prov='x'
				cont_prov='x'                
			fi
			;;
	esac
done
rm -f $registro

echo "------------------"
exit 0;
#Archivo añadido
#Archivo borrado
#Archivo cambio permisos
#Cambios en el contenido archivos
