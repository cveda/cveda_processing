#!/bin/bash

# Copyright (c) 2019 CEA
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software. You can use,
# modify and/ or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# As a counterpart to the access to the source code and rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty and the software's author, the holder of the
# economic rights, and the successive licensors have only limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading, using, modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean that it is complicated to manipulate, and that also
# therefore means that it is reserved for developers and experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and, more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.


# Create TSV tables with stats extracted from each individual dataset
# processed by FreeSurfer.

FREESURFER_HOME=/i2bm/local/freesurfer-6.0.0
export FREESURFER_HOME
. ${FREESURFER_HOME}/FreeSurferEnv.sh

SUBJECTS_DIR=/cveda/databank/processed/freesurfer6

# aparcstats2table: cortical parcellation stats
for MEAS in area volume thickness thicknessstd meancurv gauscurv foldind curvind
do
    for HEMI in rh lh
    do
        aparcstats2table --subjects `for subject in $SUBJECTS_DIR/sub-*_ses-BL ; do basename "$subject" ; done` --hemi "$HEMI" --meas "$MEAS" --tablefile "${HEMI}.aparc.${MEAS}.tsv"
    done
done

# asegstats2table: subcortical segmentation stats
for MEAS in volume mean
do
    asegstats2table --subjects `for subject in $SUBJECTS_DIR/sub-*_ses-BL ; do basename "$subject" ; done` --meas "$MEAS" --tablefile "aseg.${MEAS}.tsv"
done

# extract Euler numbers from log file
CURRENT_DIR=`dirname "$0"`
"$CURRENT_DIR"/eno2table.py --subjects `for subject in $SUBJECTS_DIR/sub-*_ses-BL ; do basename "$subject" ; done` --tablefile "euler.tsv"

for f in *.tsv
do
    sed -i -e 's/sub-\(.*\)_ses-BL/\1/' "$f"
done
