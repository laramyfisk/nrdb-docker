NRDB
=================

Out-of-the-box NRDB image (Apache+PHP+MySQL+Cards+Images).


Usage
-----

To create the image `lfisk/nrdb`, execute the following command on the nrdb-docker folder:

	docker build -t lfisk/nrdb .

You can now start your image:

	docker run -d -p 80:80 -p 3306:3306 lfisk/nrdb

