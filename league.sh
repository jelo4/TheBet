#!/bin/bash
#!/bin/sh

user=$(whoami)
echo -e "Please choose HOME team:" 
read home_team
echo -e "Please choose AWAY team:" 
read away_team
HUN=1

RES1=$(find /home/$user/league/League.pdf -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color '$home_team'' \;)
RES2=$(find /home/$user/league/League.pdf -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color '$away_team'' \;)
if [[ -z $RES1 || -z $RES2 ]]                                                                                                                                                                                                       
	then                                                                                                                                                                                                                                                                                                      #
		echo -e "Home or away Team does not exist. Exit..."                                                                                                          
		exit                                                                                                                                                                                                            
	else                                                                                                                                                                                                                    
		echo -e "Procceding..."
		pdftotext League.pdf
		sed -i 's/ATROMITOS ATH./ATROMITOS/g; s/ASTERAS TRIP./ASTERAS/g; s/PAS GIANNINA/GIANNINA/g; s/APOLLON SM./APOLLON/g' League.txt
		#Get Teams#
		teams=$(sed -n '21p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_TEAMS=($teams)
		IFS="$OIFS"
		
		#Get Games#
		games=$(sed -n '23p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_games=($games)
		IFS="$OIFS"
		
		#Get Home Wins#
		homew=$(sed -n '39p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_homew=($homew)
		IFS="$OIFS"
		
		#Get Home Draws#
		homed=$(sed -n '41p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_homed=($homed)
		IFS="$OIFS"

		#Get Home Looses#
		homel=$(sed -n '43p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_homel=($homel)
		IFS="$OIFS"	
		
		#Get Away Wins#
		awayw=$(sed -n '45p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_awayw=($awayw)
		IFS="$OIFS"
		
		#Get Away Draws#
		awayd=$(sed -n '47p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_awayd=($awayd)
		IFS="$OIFS"

		#Get Home Looses#
		awayl=$(sed -n '49p' < League.txt)
		OIFS="$IFS"
		IFS='  ' array_awayl=($awayl)
		IFS="$OIFS"			
		
		for (( i=0; i<=15; i++))
		do
			if [ "${array_TEAMS[i]}" == "$home_team" ] ; then
			        home_num="$i"
			elif [ "${array_TEAMS[i]}" == "$away_team" ] ; then
					away_num="$i"
			fi
		done
		HOME_SUM=$(bc <<< "scale=2;${array_homew[home_num]}+${array_homed[home_num]}+${array_homel[home_num]}")
		AWAY_SUM=$(bc <<< "scale=2;${array_awayw[away_num]}+${array_awayd[away_num]}+${array_awayl[away_num]}")
		
		# % of games that home_team wins:
		VAR1=$(bc <<< "scale=2;${array_homew[home_num]}/$HOME_SUM")
		# % of games that away_team looses:
		VAR2=$(bc <<< "scale=2;${array_awayl[away_num]}/$AWAY_SUM")
		
		#(Home Wins + Away Defeats)/2 :
		VAR3=$(bc <<< "scale=2;($VAR1+$VAR2)/2")
		
	
		# % of games that home_team has a draw:
		VAR1=$(bc <<< "scale=2;${array_homed[home_num]}/$HOME_SUM")
		# % of games that away_team has a draw:
		VAR2=$(bc <<< "scale=2;${array_awayd[away_num]}/$AWAY_SUM")
		
		#(Home Draws+Away Draws)/2
		VAR4=$(bc <<< "scale=2;($VAR1+$VAR2)/2")		

		# % of games that home_team looses:
		VAR1=$(bc <<< "scale=2;${array_homel[home_num]}/$HOME_SUM")
		# % of games that away_team wins:
		VAR2=$(bc <<< "scale=2;${array_awayw[away_num]}/$AWAY_SUM")
		
		#(Home Defeats+Away Wins)/2
		VAR5=$(bc <<< "scale=2;($VAR1+$VAR2)/2")
		
		#Get Team Form#
        lineNum="$(grep -n $home_team Fixture.txt | head -n 1 | cut -d: -f1)"
		echo -e " Team exists in $lineNum"
		#Get FORMA#
		form=$(sed -n ''$lineNum'p' < Fixture.txt)
		OIFS="$IFS"
		IFS=$'\n' array_form=($form)
		IFS="$OIFS"		
		
		home_team_form=${array_form[0]}
		echo -e "HOME team form is $home_team_form"
		for (( i=1; i<=5; i++))
		do
			xxx=$(echo -e "${home_team_form: -$i:1}")
			echo -e "$xxx" 
		done
		echo -e "${array_TEAMS[$home_num]} -- ${array_TEAMS[$away_num]} : "
		echo -e "Prediction: 1:0$VAR3  X:0$VAR4  2:0$VAR5"
		
		
		
fi
