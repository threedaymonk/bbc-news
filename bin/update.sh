#!/bin/sh
APP_DIR=$HOME/bbc-news
DEST_DIR=$APP_DIR/www
FRAGMENT_FILE=fragment.html
ruby $APP_DIR/bin/generate.rb > $FRAGMENT_FILE \
&& mv $FRAGMENT_FILE $DEST_DIR/$FRAGMENT_FILE
chmod a+r $DEST_DIR/$FRAGMENT_FILE

