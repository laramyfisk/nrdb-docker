#!/bin/bash

sudo service supervisor start
/scripts/wait-for-mysql.sh

# For some reason Docker forces all volumes to belong to root:root at 755.
# This is why the code below is full of sudo.

sudo mkdir -p /home/nrdb/cards/en /home/nrdb/cards/en-large

current_pack=""
while read id pack; do
	if [ "$pack" != "$current_pack" ]; then
		echo "Downloading [$pack]"
		current_pack=$pack
	fi

	sudo wget http://95.215.45.191/en/$id.png -O /home/nrdb/cards/en/$id.png
	sudo wget http://95.215.45.191/en-large/$id.png -O /home/nrdb/cards/en-large/$id.png
done < <(mysql symfony -N -B -e 'select card.code, pack.name from card left join pack on card.pack_id = pack.id order by pack.id')

ln -s /home/nrdb/cards /home/nrdb/app/web/bundles/netrunnerdbcards/images/cards

rm -rf /home/nrdb/app/app/cache/prod # This is a hack, but the line below doesn't work otherwise
php /home/nrdb/app/app/console cache:clear --env=prod --no-debug
