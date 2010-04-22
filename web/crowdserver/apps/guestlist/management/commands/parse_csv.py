from django.core.management.base import LabelCommand
from django.db.transaction import commit_on_success

from guestlist.models import Guest

import csv
import os
from datetime import datetime

class Command(LabelCommand):
    help = "Prints the CREATE TABLE, custom SQL and CREATE INDEX SQL statements for the given model module name(s)."

    args = '<csv_file, csv_file, ...>'
    label = 'csv_file'

    @commit_on_success                
    def handle_label(self, label, **options):
        """
        Reads each csv listed on the command line and imports the data
        """
        print 'weee'
        if not os.path.exists(label):
            print 'ERROR: file does not exist: %s' % label
        else:
            f = open(label, 'rU')
            #line_reader = csv.reader(f)
            line_reader = csv.reader(f, dialect=csv.excel)
            headers = line_reader.next()
            for row in line_reader:
                g = whitney_make_guest(row)
                print g
                g.save()


def whitney_make_guest(row):
    """
    name = row[0]
    access = row[1]
    criteria = row[2]
    """
    name = u'%s - %s' % (row[0], row[1])
    vip = False
    event_date = None
    if row[1] == '23':
        event_date = datetime(2010, 2, 23, 0, 0)
    elif row[1] == 'V23' or row[1] == 'v23':
        event_date = datetime(2010, 2, 23, 0, 0)
        vip = True
    elif row[1] == '24':
        event_date = datetime(2010, 2, 24, 0, 0)
    elif row[1] == 'V24' or row[1] == 'v24':
        event_date = datetime(2010, 2, 24, 0, 0)
        vip = True
    else:
        print 'Found unknown access code: %s' % (row[1])

    #if 3 in row:
    #    print 'weeee'

    g = Guest(name=name,
              vip=vip,
              criteria=row[2],
              event_date=event_date,
              arrived=False,
              plus_count=1,
              plus_counted=0)
    return g
