#!/bin/bash
set -e

python -c "import sys; assert sys.hexversion >= 0x02070000, 'python too old'"
python -c "import wheel" || python -m pip install wheel
export NUMBER=$(python -c "import jiradls; print jiradls.__version__")
git tag -a v${NUMBER} -m v${NUMBER}
git push origin v${NUMBER}
python setup.py clean --all
python setup.py sdist bdist_wheel upload
python setup.py clean --all

if [[ -x /dls_sw/apps/jira/deploy ]]; then
  read -p "Do you want to deploy this @DLS for all users? " -n 1 -r
  echo # move to new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    /dls_sw/apps/jira/deploy ${NUMBER}
  fi
fi
