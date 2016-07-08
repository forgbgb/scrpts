#!/usr/bin/env python
import xml.etree.ElementTree as ET
from optparse import OptionParser
import os

if __name__=='__main__' :
    parser = OptionParser()

    parser.add_option("-f", "--from", dest="from_xml",
                  help="XML File A", metavar="foo.xml")

    (options, args) = parser.parse_args()

    if not  options.from_xml :
        print " XML files needed"

####
    from_xmlobj = ET.parse(options.from_xml)
    from_xmlroot = from_xmlobj.getroot()

    for elem in from_xmlroot.findall('project') :
       print elem.get("name")

