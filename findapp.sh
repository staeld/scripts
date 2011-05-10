#!/bin/bash
RESULTSFILE="${HOME}/.searchresults"
case $1 in
    -h|--help|'')
        echo $0 - Search for a given pattern in the most common \$PATHs
        echo -e "Syntax: $0 <pattern> [additional PATH]"
        exit 0
    ;;    
    *)
        SEARCH=$1
        if [ -e $RESULTSFILE ]; then
            echo The file $RESULTSFILE is already existing
            echo This file would normally be used for caching of your search results
            echo Please choose whether to use another filename, append the search results to the
            echo already existing file, remove the old file, or abort.
            echo -e "Valid commands: other | ignore | remove | abort"
            read FILECHOICE
            case $FILECHOICE in
                other)
                    RESULTSFILE=''
                    echo Please specify another file location \(full path\):
                    read RESULTSFILE
                ;;
                ignore)
                    echo Appending search result to the already-existing search log...
                ;;
                remove)
                    echo Removing pre-existing file..
                    rm $RESULTSFILE
                    echo File removed!
                    echo -e "\n"
                ;;
                abort)
                    echo Aborting!
                    exit 0
                ;;
                *)
                    echo Not a valid choice!
                    echo Aborting...
                    exit 1
                ;;
            esac
        else
            touch $RESULTSFILE
        fi
        if [ -z $(echo $2) ]; then
            sleep 0
        else
            OWNDIR=$2
            echo Using specified directory \"${OWNDIR}\" as addition to PATHs...
        fi
        echo -e "Starting search at `date +%F` `date +%H:%M:%S`..." >> $RESULTSFILE
        for DIR in /bin /sbin /usr/bin /usr/sbin ${OWNDIR}; do
            echo "*** Files found in $DIR :" >> $RESULTSFILE
            find $DIR -name \*${SEARCH}\* >> $RESULTSFILE
        done
        echo -e "Search completed at `date +%F` `date +%H:%M:%S`" >> $RESULTSFILE
        VIEW='x'
        while [ $VIEW = 'x' ]; do
            echo Please choose how you want to see the file results:
            echo through \`less\', through \`cat\', or if you do not view it right now.
            echo -e "Valid options: less | cat | none"
            read VIEWOPT
            case $VIEWOPT in
                less)
                    less $RESULTSFILE
                    break
                ;;
                cat)
                    echo -e "\n"
                    cat $RESULTSFILE
                    echo -e "\n"
                    break
                ;;
                none)
                    echo Keeping results file at ${RESULTSFILE}..
                    break
                ;;
                *)
                    echo Invalid option!
                    DEL='x'
                ;;
            esac
        done
        DEL='x'
        while [ $DEL = 'x' ]; do
            echo Do you want to delete the search results file? 
            echo The file is located at $RESULTSFILE
            echo Valid options: yes \| no
            read DEL
            case $DEL in
                y|Y|yes|Yes)
                    echo Deleting $RESULTSFILE ...
                    rm $RESULTSFILE
                    echo File deleted
                    break
                ;;
                n|N|no|No)
                    echo Keeping $RESULTSFILE
                    break
                ;;
                *)
                    echo Invalid option!
                    DEL='x'
                ;;
            esac
        done
    ;;
esac
#EOF
