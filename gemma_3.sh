#!/bin/sh
# Gemini : la mejor por su peso!
# modelo gemma3:1b de Google, Necesita 2 GB de RAM para funcionar, y su descarga ocupa aproximadamente 815 MB
# ollama --version  ( muestra la version de ollla actual instalada )
# ollama help ( muesta ayuda con las opciones )
# ollama list  ( muestra los modelos instalados presentes en local )
# ollama run nombre_fichero_modelo  ( ejecuta el modelo del nombre del fichero )
# ollama show nombre_fichero_modelo ( muestra informacion del nombre del fichero )
# ollama pull nombre_fichero_modelo ( re-ejecuta el modelo del nombre del fichero )
# ollama stop nombre_fichero_modelo ( para la ejecutcion del modelo del nombre del fichero )
# ollama rm nombre_fichero_modelo ( borra el modelo del nombre del fichero )



ollama run gemma3:1b


