from django.core.management.base import LabelCommand
from django.db.transaction import commit_on_success

from guestlist.models import Guest

import csv
import os
from datetime import datetime

class Command(LabelCommand):
    help = "Creates guests for the supplied CSV file(s)."

    args = '<csv_file, csv_file, ...>'
    label = 'csv_file'

    @commit_on_success
    def handle_label(self, label, **options):
        """
        Reads each csv listed on the command line and imports the data
        """
        if not os.path.exists(label):
            print 'ERROR: file does not exist: %s' % label
        else:
            print 'importing %s...' % (label,)
            f = open(label, 'rU')
            line_reader = csv.reader(f, dialect=csv.excel)
            headers = line_reader.next()
            for row in line_reader:
                g = make_guest(row)
                print g
                g.save()


def make_guest(row):
    """
    first name = row[0]
    last name = row[1]
    iml_num = row[2]
    re_id = row[3]
    table_name = row[4]
    email = row[5]
    phone = row[6]
    """
    
    # Change these if the csv shows up in a different order
    idx_first_name = 1
    idx_last_name = 0
    idx_iml_num = 2
    idx_re_id = 3
    idx_table_name = 4
    idx_email = 5
    idx_phone = 6
        
    name = u'%s, %s' % (row[idx_last_name], row[idx_first_name])

    g = Guest(name=name,
              iml_num = row[idx_iml_num],
              re_id = row[idx_re_id],
              table_name = row[idx_table_name],
              email = row[idx_email],
              phone_number = row[idx_phone]
            )
    return g
