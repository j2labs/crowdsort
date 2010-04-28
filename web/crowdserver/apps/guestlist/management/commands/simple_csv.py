# -*- coding: utf-8 -*-

import sys


READY_FOR_FIELD = 1
IN_FIELD = 2
IN_QUOTE_FIELD = 3
FIELD_COMPLETE = 4

QUOTE = u'"'

class DudeUrGettinACSV():
    """
    A really simple CSV reader that's unicode-safe. Doesn't support multi-line field, and probably a few other to-spec
    features. Certainly doesn't support the bells and whistles that the csv module takes care of.
    """
    
    def __init__(self, inStream, delimiter = u',', stripFields = True, encoding = 'utf-8'):
        self._inStream = inStream
        self._delimiter = delimiter
        self._stripFields = stripFields
        self._encoding = encoding
    
    def __iter__(self):
        return self
    
    def next(self):
        line = self._inStream.next()
        return self._parse(line)
    
    def _parse(self, line):
        row = []
        state = READY_FOR_FIELD
        currentField = u''
        
        for c in line.decode(self._encoding):
            
            if state == READY_FOR_FIELD:
                if c == QUOTE:
                    state = IN_QUOTE_FIELD
                elif c == self._delimiter:
                    state = FIELD_COMPLETE
                else:
                    currentField += c
                    state = IN_FIELD
            
            elif state == IN_FIELD:
                if c == self._delimiter:
                    state = FIELD_COMPLETE
                else:
                    currentField += c
        
            elif state == IN_QUOTE_FIELD:
                if c == QUOTE:
                    state = FIELD_COMPLETE
                else:
                    currentField += c
        
            if state == FIELD_COMPLETE:
                
                if self._stripFields:
                    currentField = currentField.strip()
                
                row.append(currentField)
                currentField = u''
                state = READY_FOR_FIELD
        
        # tack on the last field
        if self._stripFields:
            currentField = currentField.strip()
        
        row.append(currentField)
        currentField = u''
        state = READY_FOR_FIELD
        
        return row

def main():
    f = open(sys.argv[1], 'rU')
    reader = DudeUrGettinACSV(f)
    for row in reader:
        print row

if __name__ == '__main__':
    main()