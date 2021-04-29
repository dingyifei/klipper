#!/bin/bash
#Automatically generate a set of po and md files for Localization
#in the ./locales/[language]/ folder
#requirement: pip install mdpo


for file in docs/*.md; do
  mdfile=${file/docs\//}
  potfile=${mdfile//.md/.pot}
  echo "Converting $mdfile to $potfile"
  md2po $mdfile --md-encoding utf-8 --po-encoding utf-8 \
  -e utf-8 -w 71 -q -s --po-filepath docs/locales/en/$potfile
done

for dir in docs/locales/*/; do
  dir=${dir%*/}
  dir=${dir##*/}
  if [ $dir != "en" ]; then
    echo "Updating $dir"
    for file in docs/*.md; do
      mdfile=${file/docs\//}
      pofile=${mdfile//.md/.po}
      echo "Converting $mdfile to $pofile"
      md2po $mdfile --md-encoding utf-8 --po-encoding utf-8 \
      -e utf-8 -w 71 -q -s --po-filepath docs/locales/$dir/LC_MESSAGES/$pofile

      echo "Converting $pofile to $mdfile"
      po2md $mdfile --md-encoding utf-8 --po-encoding utf-8 \
      --pofiles docs/locales/$dir/LC_MESSAGES/$pofile -q -s docs/locales/$dir/$mdfile
    done
  fi
done
