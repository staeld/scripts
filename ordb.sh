#!/bin/bash
# ordb.sh - enkel wrappar for å bruka ordbanken som ordbok
# Opphavsrett Stæld Lakorv, 2012 <staeld@illumine.ch>
# Sluppe under GPLv3+, sjå <http://www.gnu.org/licenses/>

function help() {
    echo "Bruk: grunnord [kriterium1] [kriterium2] ..."
    echo
    echo "Dette slår opp ordet «grunnord» i fullformsordlista til Norsk ordbank,"
    echo "med eventuell filtrering etter eitt eller fleire kriterium."
    echo "Mulige kriterie er m.a. «subst», «fem» (hokjønn), «verb», «pret» (preteritum),"
    echo "og så vidare." # Grunnordet kan også innehalda regulære uttrykk."
    echo "Skriptet gjer bruk av «ordbanken» av Karl Ove Hufthammer <karl@huftis.org>."
}

help="Bruk: grunnord [kriterium1] [kriterium2] ...\n\n
Dette slår opp ordet «grunnord» i fullformsordlista til Norsk ordbank,\n
med eventuell filtrering etter eitt eller fleire kriterium.\n
Mulige kriterie er m.a. «subst», «fem» (hokjønn), «verb», «pret» (preteritum),\n
og så vidare.\n
Skriptet gjer bruk av «ordbanken» av Karl Ove Hufthammer <karl@huftis.org>."

if [ -z $1 ]; then
    until [ "$spr" == "nn" ] || [ "$spr" == "nb" ]; do
        read -p "Språk? [nn/nb]: " spr
        if [ -z "$spr" ]; then
            spr="nn"
        fi
    done
else
    case $1 in
        *help|*hjelp|-h)
            help
            exit 0
            ;;
        nn|nyn*)
            spr="nn"
            ;;
        nb|bok*)
            spr="nb"
            ;;
    esac
fi

while [ 1 ]; do
    clear
    read -e -p "Ord: " ord
    if [ "$ord" == "quit" ] || [ "$ord" == "exit" ] || [ "$ord" == "avslutt" ]; then
        exit 0
    elif [ -z "$ord" ]; then
        #text=$help
        help
        read -p "Trykk enter for nytt søk..."
    else
        echo -e "$(ordbanken -s $spr -- $ord)\n\nTrykk Q for nytt søk..." | less
        #echo "----"
        # Regexp kutta ut fordi alle ord er delvise treff og ikkje heile ord
        #ordbanken -s $spr -- $ord
    fi
    #text="${text}----\nTrykk Q for nytt søk..."
    #read -p "Trykk Q for nytt søk..."
    #echo $text | less
done
