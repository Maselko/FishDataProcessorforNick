# FISH Version
# Written by Sebastian Tamon Hascilowicz
# written in 03.06.2019
################################################################################

bold=$(tput bold)
normal=$(tput sgr0)
sped=1

pmaker() {
  inp=$1
  inp2=$(($inp/2))
  pnum=${inp2%\.*}
  nnum=$((50-$pnum))
  v=$(printf "%-${pnum}s" "#")
  w=$(printf "%-${nnum}s" ".")
  echo " {${v// /#}${w// /.}} $inp% "
}
while :; do
  clear
  echo -e "\033[1;34mSUNFISH:$normal OPTION"
  echo " Current directory path:"
  pwd
  echo " Enter 'h' for help, 'exit' to exit the program"
  echo " Is the directory path correct?"
  read -p " ([y]/n) " opt
  if [ -z "$opt" ] || [ "$opt" == "y" ] || [ "$opt" == "Y" ]; then
    #interpolation option
    clear
    if [ -d "crustacean" ]; then
      echo -e "\033[1;34mSUNFISH:$normal RUNNING"
      echo " Choose which interpolation field to use:"
      echo " 1: B175015.csv         3: VB175015.csv"
      echo " 2: B400015.csv         4: VB400015.csv"
      read netnum
      if [ "$netnum" == "1" ]; then
        cd crustacean
        if [ -f '1.csv' ]; then
          cp 1.csv gillnet.csv
        else
          echo -e "\033[1;34mSUNFISH:$normal ERROR"
          echo " Error: '1.csv' is not in the same directory"
          break
        fi
        cd ..
      elif [ "$netnum" == "2" ]; then
        cd crustacean
        if [ -f '2.csv' ]; then
          cp 2.csv gillnet.csv
        else
          echo -e "\033[1;34mSUNFISH:$normal ERROR"
          echo " Error: '2.csv' is not in the same directory"
          break
        fi
        cd ..
      elif [ "$netnum" == "3" ]; then
        cd crustacean
        if [ -f '3.csv' ]; then
          cp 3.csv gillnet.csv
        else
          echo -e "\033[1;34mSUNFISH:$normal ERROR"
          echo " Error: '3.csv' is not in the same directory"
          break
        fi
        cd ..
      elif [ "$netnum" == "4" ]; then
        cd crustacean
        if [ -f '4.csv' ]; then
          cp 4.csv gillnet.csv
        else
          echo -e "\033[1;34mSUNFISH:$normal ERROR"
          echo " Error: '4.csv' is not in the same directory"
          break
        fi
        cd ..
      else
        break
      fi
    else
      echo -e "\033[1;34mSUNFISH:$normal ERROR"
      echo " Error: 'crustacean' is not in the same directory"
      break
    fi
    sleep 0.1s
    #run
    fn=2
    for filename in *.csv; do
      fn=$(($fn+1))
    done
    #progress maker
    es=$((100/$fn))
    pb=$(($es/3))
    fornum= 0
    clear
    echo -e "\033[1;34mSUNFISH:$normal RUNNING"
    echo " Preparing to run..."
    prog=$(($fornum+$pb))
    pmaker $prog
    if [ -d "old" ]; then
      cd crustacean
        if [ -f "plankton.py" ]; then
          cd ..
        else
          echo -e "\033[1;34mSUNFISH:$normal ERROR"
          echo " Error: 'plankton.py' is not in the crustacean"
          break
        fi
    else
      mkdir old
      cd crustacean
        if [ -f "plankton.py" ]; then
          cd ..
        else
          echo -e "\033[1;34mSUNFISH:$normal ERROR"
          echo " Error: 'plankton.py' is not in the crustacean"
          break
        fi
    fi
    sleep 0.3s
    for filename in *.csv; do
      clear
      echo -e "\033[1;34mSUNFISH:$normal RUNNING"
      echo " Managing files for $filename..."
      fornum=$(($fornum+$es))
      prog=$(($fornum-$pb))
      pmaker $prog
      cp $filename in.csv
      mv $filename old
      mv in.csv crustacean
      cd crustacean
      sleep 0.5s
      #Running
      clear
      echo -e "\033[1;34mSUNFISH:$normal RUNNING"
      echo " Computing $filename..."
      prog=$(($fornum+$pb))
      pmaker $prog
      python3 plankton.py
      sleep 1.2s
      rm -f in.csv
      mv out.csv ../
      cd ..
      cp out.csv $filename
      sleep 0.2s
      rm -f out.csv
    done
    sleep 0.3s
    clear
    echo -e "\033[1;34mSUNFISH:$normal RUNNING"
    echo " Cleaning up..."
    fornum=$(($fornum+$es))
    prog=$(($fornum+$pb))
    pmaker $prog
    cd crustacean
    rm -f gillnet.csv
    cd ..
    sleep 0.2s
    clear
    echo -e "\033[1;34mSUNFISH:$normal FINISH"
    echo " Finished calculation"
    echo " {##################################################} 100%"
    break
  elif [ "$opt" == "h" ] || [ "$opt" == "H" ]; then #completed
    clear
    echo -e "\033[1;34mSUNFISH:$normal HELP"
    echo " Welcome to help! These are all commands used in this program"
    echo " "
    echo "  ${bold}Running(y): ${normal}This command calculates runs 'plankton.py' file. Only works in Option."
    echo "  ${bold}Path Settings(n): ${normal}This command allows you to change directory. Only works in Option."
    echo "  ${bold}help(h): ${normal}This command shows this page."
    echo "  ${bold}version(v): ${normal}Shows the version of this program. Only works in Option."
    echo "  ${bold}option(back): ${normal}Gets back to the (first) page. This command works in path settings."
    echo "  ${bold}exit(exit): ${normal}Terminates this program. This command works in any mode."
    echo " "
    echo " press 'enter' to go back."
    read -p "" opt
  elif [ "$opt" == "n" ] || [ "$opt" == "N" ]; then #completed
    while true; do
      clear
      echo -e "\033[1;34mSUNFISH:$normal PATH SETTINGS"
      echo " Write 'back' to get back to the option menu."
      echo " Current path:"
      pwd
      read -p " cd " drctry
      if [ "$drctry" == "back" ]; then
        opt= $y
        continue 2
      elif [ "$drctry" == "exit" ]; then
      #exit
        clear
        echo -e "\033[1;34mSUNFISH:$normal EXIT"
        read -p " Do you want to exit?([y]/n) " opt
        if [ "$opt" == "y" ] || [ "$opt" == "Y" ] || [ -z "$opt" ]; then
          clear
          opt= $drctry
          continue 2
        fi
      else
        cd $drctry
      fi
    done
  elif [ "$opt" == "v" ] || [ "$opt" == "V" ]; then #completed
    clear
    echo -e "\033[1;34mSUNFISH:$normal VERSION"
    echo " "
    echo -e "  \033[1;34m   ° o _____/|     $normal Sunfish"
    echo -e "  \033[1;34m    o / o     \    $normal Version : 0.8.0"
    echo -e "  \033[1;34m     °>  <]    |   $normal Written by: S.T. Haściłowicz"
    echo -e "  \033[1;34m      \_____  /    $normal On: 18.05.2019"
    echo -e "  \033[1;34m            \|     $normal Using $(python3 --version)"
    echo " "
    read -p "" opt
  elif [ "$opt" == "exit" ]; then #completed
    clear
    echo -e "\033[1;34mSUNFISH:$normal EXIT"
    read -p " Do you want to exit?([y]/n) " opt
    if [ "$opt" == "y" ] || [ "$opt" == "Y" ] || [ -z "$opt" ]; then
      clear
      break
    fi
  fi
done
