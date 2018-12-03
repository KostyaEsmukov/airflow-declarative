PROJECT     := airflow_declarative
PYTHON_VENV := python3
PYTHON      := python

.PHONY: venv
venv:
	$(PYTHON_VENV) -m venv venv

.PHONY: develop
develop:
	pip install --upgrade setuptools pip wheel setuptools-pkg
	# Airflow since 1.10 requires an env var to be set before installation:
	#
	# RuntimeError: By default one of Airflow's dependencies installs
	# a GPL dependency (unidecode). To avoid this dependency set
	# SLUGIFY_USES_TEXT_UNIDECODE=yes in your environment when you install
	# or upgrade Airflow. To force installing the GPL version
	# set AIRFLOW_GPL_UNIDECODE
	SLUGIFY_USES_TEXT_UNIDECODE=yes pip install 'apache-airflow<1.10'
	SLUGIFY_USES_TEXT_UNIDECODE=yes pip install -e .[develop]

.PHONY: check
check: check-lint check-coverage


.PHONY: check-coverage
check-coverage:
	@${PYTHON} -m pytest


.PHONY: check-lint
check-lint: check-imports check-codestyle check-errors

.PHONY: check-imports check-codestyle check-errors
check-imports:
	@${PYTHON} -m isort.main -df -c -rc setup.py src/ tests/
check-codestyle:
	@${PYTHON} -m flake8 --statistics --show-source setup.py src/ tests/
check-errors:
	@${PYTHON} -m pylint --rcfile=.pylintrc -E src/$(PROJECT)