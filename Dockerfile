FROM opensciencegrid/osgvo-ubuntu-20.04:latest

LABEL opensciencegrid.name="RASPA2"
LABEL opensciencegrid.description="General purpose classical simulation package. It can be used for the simulation of molecules in gases, fluids, zeolites, aluminosilicates, metal-organic frameworks, carbon nanotubes and external fields."
LABEL opensciencegrid.url="https://github.com/iraspa/RASPA2"
LABEL opensciencegrid.category="Tools"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-raspa2"

# deps
RUN apt -y clean && \
    apt -y update && \
    apt -y install autotools-dev build-essential libtool

RUN cd /tmp && \
    git clone https://github.com/iRASPA/RASPA2.git && \
    cd RASPA2 && \
    git checkout v2.0.41 && \
    rm -rf autom4te.cache && \
    mkdir m4 && \
    aclocal && \
    autoreconf -i && \
    automake --add-missing && \
    autoconf && \
    ./configure --prefix=/opt/raspa2 && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf RASPA2

COPY labels.json /.singularity.d/
COPY 90-osgvo-raspa2.sh /.singularity.d/env/90-osgvo-raspa2.sh

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

