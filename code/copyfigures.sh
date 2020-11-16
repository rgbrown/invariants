#!/bin/bash

for filename in images/f_transformed_*.png; do
    convert $filename -trim $filename
    cp $filename ../paper/Figs
done

for filename in images/*_signature.png; do
    convert $filename -trim $filename
    cp $filename ../paper/Figs
done
