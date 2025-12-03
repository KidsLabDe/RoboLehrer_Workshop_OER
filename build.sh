#!/bin/bash

npx @marp-team/marp-cli Moderationskarten/workshop-moderationskarten.md --pdf

# create tmp dir
mkdir -p .tmp

# copy all md files
cp _index.md .tmp/0-OER.md
# copy and reaname all the index.md (index.md is required for website generation)
# take only the folders starting with a number
for f in ??-*/*.md; do
    # ls $f
    cp $f .tmp/$(ls $f | sed "s/\//-/g")
done


mkdir -p .tmp/Rollenkarten
cp Rollenkarten/* .tmp/Rollenkarten/


# copy all the pngs
cp *.png .tmp/
cp *.jpg .tmp/
cp *.jpeg .tmp/
cp */*.png .tmp/
cp */*.jpg .tmp/
cp */*.jpeg .tmp/

# step into the temporal depths
cd .tmp

# replace special containers
for f in $(find . -name "*.md"); do
    # echo "::::::file $f\n"
    ## {{%notice note überschrift hier%}} -> ::: note\n###überschrift
    ## note -> note
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+note[[:space:]]+(.*)%}}/::: note  \n**\1**\n/g" $f
    ## task -> note
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+task[[:space:]]+(.*)%}}/::: note  \n**\1**\n/g" $f
    ## warning -> warning
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+warning[[:space:]]+(.*)%}}/::: warning  \n**\1**\n/g" $f
    ## success -> tip
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+success[[:space:]]+(.*)%}}/::: tip  \n**\1**\n/g" $f
    ## {{% /notice %}} => :::
    sed -i.bak -E "s/{{%[[:space:]]*\/[[:space:]]*notice[[:space:]]*%}}/:::/g" $f


done

# convert with pandoc
pandoc *.md -o "../RoboLehrer an die Macht.docx"
pandoc *.md -o "../RoboLehrer an die Macht.pdf" --from markdown --template "../eisvogel.latex" --filter pandoc-latex-environment --listings



# cd ..


mkdir -p Rollenkarten
cp ../Rollenkarten/*.md Rollenkarten/

cd Rollenkarten

for f in $(find . -name "*.md"); do
    # echo "::::::file $f\n"
    ## {{%notice note überschrift hier%}} -> ::: note\n###überschrift
    ## note -> note
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+note[[:space:]]+(.*)%}}/::: note  \n**\1**\n/g" $f
    ## task -> note
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+task[[:space:]]+(.*)%}}/::: note  \n**\1**\n/g" $f
    ## warning -> warning
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+warning[[:space:]]+(.*)%}}/::: warning  \n**\1**\n/g" $f
    ## success -> tip
    sed -i.bak -E "s/{{%[[:space:]]*notice[[:space:]]+success[[:space:]]+(.*)%}}/::: tip  \n**\1**\n/g" $f
    ## {{% /notice %}} => :::
    sed -i.bak -E "s/{{%[[:space:]]*\/[[:space:]]*notice[[:space:]]*%}}/:::/g" $f


done


pandoc 01-Lehrer.md -o "../../Rollenkarte_Lehrer.pdf" --from markdown --template "../eisvogel.latex" --filter pandoc-latex-environment --listings
pandoc 02-Schueler.md -o "../../Rollenkarte_Schueler.pdf" --from markdown --template "../eisvogel.latex" --filter pandoc-latex-environment --listings
pandoc 03-Eltern.md -o "../../Rollenkarte_Eltern.pdf" --from markdown --template "../eisvogel.latex" --filter pandoc-latex-environment --listings
pandoc 04-Rektor.md -o "../../Rollenkarte_Rektor.pdf" --from markdown --template "../eisvogel.latex" --filter pandoc-latex-environment --listings


# mission accomplished, leave .tmp/
cd ..
cd ..

pwd

# get rid of .tmp/
rm -r .tmp
