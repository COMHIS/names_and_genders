# names_and_genders
A small script which creates a historical list of forenames and genders

The script (gender.r) downloads data from:

http://sas-space.sas.ac.uk/748/
http://sas-space.sas.ac.uk/749/
http://sas-space.sas.ac.uk/750/
http://sas-space.sas.ac.uk/751/
http://reshare.ukdataservice.ac.uk/853082/

It :

1) Downloads data
2) extracts/assigns forenames, years of birth/death (or baptism/burial), and gender.
3) clean up entries which are broken/ambiguous
4) standardizes names
5) creates a range of years a name may have been active
6) counts the occurances of a given name

Full credit for data collection can be found at the above webpages, but in hope of correctly attributing effort:

*Wrigley, E.A. and Davies, R.S. and Oeppen, J.E. and Schofield, R.S. (2018). 26 English parish family reconstitutions. [Data Collection]. Colchester, Essex: UK Data Archive. 10.5255/UKDA-SN-853082
*Newton, Gill and Baker, Philip (2007) Family Reconstitution Data (Cheapside). [Dataset]
*Newton, Gill (2007) Family Reconstitution Data (Clerkenwell). [Dataset]
*Newton, Gill (2007) Parish Register Data (Clerkenwell). [Dataset]
*Newton, Gill and Baker, Philip (2007) Parish Register Data (Cheapside). [Dataset]
