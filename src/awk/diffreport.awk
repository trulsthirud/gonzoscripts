#diffreport.awk Produces difference report between two or more sets of property files
# 
#  Create a subdirectory with a meaningful name for each set of property files, like DEV and PROD
#  Cygwin-users: Take care that the property files have unix line endings. Use dos2unix if not. 
#
#  Run like this to create a CSV-report:
#
#  find . -name "*.properties" | gawk -f diffreport.awk
#
#  The resulting report has four columns for two sets of property files, like this:
#
# "mfordeler.properties"; "diff"; "DEV"; "PROD"
# "property1"; "*"; "dev-value"; "prod-value"
# "property2"; ""; "dev-value"; "prod-value"
#
# The diff-column contains a star "*" if the property values are different

BEGIN   { OFS = ":"}

#
# reads in all properties from file with name filename
#
function read_properties(filename,    field,line,property,value,propertyfile) {
   split(filename,field, "/")
   environ = field[2]
   envirlist[environ]++
   propertyfile = field[3]
   propertyfiles[propertyfile]++
   while(getline line < filename) {
     if (line ~ /^ *$/) continue;
     if (line ~ /^#/)  continue;
     split(line,prop,"=")
     property = prop[1]
     value = prop[2]
     # print environ,propertyfile, property, value, line
     envirproplist[environ,propertyfile,property] = value
     if (! (propertyfile, property) in filepropertyseen) {
       fileproplist[propertyfile] = fileproplist[propertyfile] ";" property  # no duplicates
       filepropertyseen[propertyfile, property]++
     }  
   } 	
}

#
# makes the report after all property files are read
#
function make_report() {
    num_environs = asorti(envirlist)

    num_propertyfiles = asorti(propertyfiles)
    for (i = 1; i<= num_propertyfiles; i++) {
      propertyfilename = propertyfiles[i]
      printf("\n\n\"%s\";\"ulike\"", propertyfilename)
      for (l = 1; l<= num_environs; l++) {
        printf(";\"%s\"",envirlist[l])
      }
      print ""
      num_props = split(fileproplist[propertyfilename], propname, ";") 
      asort(propname)
      for (j = 2; j<= num_props; j++) {
        pname = propname[j]
        header= sprintf("\"%s\"", pname)
        suffix = ""
        delete(seenvalues)
        for (k = 1; k<=num_environs; k++) {
          value = envirproplist[envirlist[k],propertyfilename,pname]
          suffix = suffix sprintf(";\"%s\"", value)
          seenvalues[value]++
        }
        ulike = length(seenvalues) == 1 ? ";\"\"" : ";\"*\""
        print header ulike suffix
	    }
	  }
  }

       { read_properties($0) }
END    { make_report() } 