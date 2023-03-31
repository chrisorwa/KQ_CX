
# load required libraries
library(rsconnect)

# authorize account
rsconnect::setAccountInfo(name='blackorwa',
                          token='8F646002F7A757408ACDFCD647010CFE',
                          secret='+HXf/kJSxfIuhnrCQcAm9FeRp4mAPCma/uvVuv9R')

rsconnect::deployApp('path/to/your/app')