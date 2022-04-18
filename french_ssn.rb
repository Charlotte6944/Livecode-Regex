require "amazing_print"
require "date"
require "yaml"

# REGEX
SSN_PATTERN = /^(?<gender>1|2)\s(?<year>\d{2})\s(?<month>0[1-9]|1[0-2])\s(?<dep>0[1-9]|[1-9][0-9])\s\d{3}\s\d{3}\s(?<key>\d{2})/
# Gender (1 == man, 2 == woman)
def gender(ssn)
  if ssn.match(SSN_PATTERN)[:gender].to_i == 1
    "man"
  else
    "woman"
  end
end
# Year of birth (84)
def year(ssn)
  ssn.match(SSN_PATTERN)[:year].to_i + 1900
end
# Month of birth (12)
def month(ssn)
  Date::MONTHNAMES[ssn.match(SSN_PATTERN)[:month].to_i]
end
# Department of birth (76, basically included between 01 and 99)
def dep(ssn)
  YAML.load_file('data/french_departments.yml')[ssn.match(SSN_PATTERN)[:dep]]
end
# 6 random digits (451 089)
# A 2 digits key (46, equal to the remainder of the division of (97 - ssn_without_key) by 97.)
def validatekey?(ssn)
  (97 - ssn.delete(" ")[0..-3].to_i) % 97 == ssn.match(SSN_PATTERN)[:key].to_i
end

def french_ssn_info(ssn)
  if ssn.match?(SSN_PATTERN) && validatekey?(ssn)
    gender = gender(ssn)
    year = year(ssn)
    month = month(ssn)
    dep = dep(ssn)
    "a #{gender}, born in #{month}, #{year} in #{dep}"
  else
    "number not valid"
  end
end

ssn = "1 84 12 76 451 089 46"
ap french_ssn_info(ssn)
# "a man, born in December, 1984 in Seine-Maritime."

ap french_ssn_info("123")
# "The number is invalid"
