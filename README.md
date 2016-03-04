# smubib

This will let you convert Google Spreadsheet data to BibTeX files.

##Example use

	wget 'https://docs.google.com/spreadsheets/d/1fDMyg8BK47tJjHBKtCiMwaRUTJ12ZeCZqAZqYSNxdaE/pub?output=csv' -O smu.csv
	perl smubib.pl smu.csv > smu.bib 

##Dependencies

You'll need `Text::CSV`. Install it with (on Ubuntu): 

	sudo cpan Text::CSV


