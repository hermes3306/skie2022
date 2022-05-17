#python3 -m pip install -r etc/pip/compile-requirements.txt
cd mongo5.3
python3 buildscripts/scons.py install-all
cd ..

